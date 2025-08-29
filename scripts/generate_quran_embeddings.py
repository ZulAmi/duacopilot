#!/usr/bin/env python3
"""
Quran Embeddings Generator

This script generates embeddings for the complete Quran using sentence-transformers.
It creates embeddings compatible with the QuranVectorIndex in DuaCopilot.

Requirements:
    pip install sentence-transformers requests tqdm

Usage:
    python scripts/generate_quran_embeddings.py
"""

import json
import time
from pathlib import Path
from typing import Any, Dict, List

import requests

try:
    from sentence_transformers import SentenceTransformer
    from tqdm import tqdm
except ImportError as e:
    print(f"Missing required packages. Please install with:")
    print("pip install sentence-transformers requests tqdm")
    exit(1)


class QuranEmbeddingGenerator:
    def __init__(self):
        self.base_url = "https://api.alquran.cloud/v1"
        self.model = SentenceTransformer('all-MiniLM-L6-v2')  # 384 dimensions
        self.embedding_dimension = 384
        
        # Output paths
        self.project_root = Path(__file__).parent.parent
        self.embeddings_path = self.project_root / "assets" / "data" / "quran_embeddings_minilm.json"
        self.verses_path = self.project_root / "assets" / "data" / "quran_verses_min.json"
        
    def fetch_complete_quran(self, edition: str = "en.sahih") -> List[Dict[str, Any]]:
        """Fetch complete Quran from Al Quran Cloud API"""
        print(f"🔄 Fetching complete Quran from API (edition: {edition})...")
        
        verses = []
        
        # The Quran has 114 Surahs
        for surah_num in tqdm(range(1, 115), desc="Fetching Surahs"):
            try:
                url = f"{self.base_url}/surah/{surah_num}/{edition}"
                response = requests.get(url, timeout=30)
                response.raise_for_status()
                
                surah_data = response.json()['data']
                
                for ayah in surah_data['ayahs']:
                    verse_data = {
                        'number': ayah['number'],
                        'surah_number': surah_data['number'],
                        'number_in_surah': ayah['numberInSurah'],
                        'surah_english': surah_data['englishName'],
                        'surah_arabic': surah_data['name'],
                        'revelation_type': surah_data['revelationType'],
                        'text': ayah['text'].strip()
                    }
                    verses.append(verse_data)
                
                # Rate limiting - be respectful to the API
                time.sleep(0.1)
                
            except Exception as e:
                print(f"❌ Error fetching Surah {surah_num}: {e}")
                continue
        
        print(f"✅ Successfully fetched {len(verses)} verses")
        return verses
    
    def generate_embeddings(self, verses: List[Dict[str, Any]]) -> Dict[str, List[float]]:
        """Generate embeddings for all verses"""
        print(f"🧠 Generating embeddings for {len(verses)} verses...")
        
        # Prepare texts for embedding
        texts = []
        verse_numbers = []
        
        for verse in verses:
            # Create rich text for better semantic understanding
            surah_context = f"Surah {verse['surah_english']} ({verse['surah_arabic']})"
            verse_context = f"Verse {verse['number_in_surah']}"
            full_text = f"{surah_context}, {verse_context}: {verse['text']}"
            
            texts.append(full_text)
            verse_numbers.append(str(verse['number']))
        
        # Generate embeddings in batches for efficiency
        print("🔄 Computing sentence embeddings...")
        embeddings = self.model.encode(texts, show_progress_bar=True, batch_size=32)
        
        # Verify dimensions
        if len(embeddings[0]) != self.embedding_dimension:
            raise ValueError(f"Expected {self.embedding_dimension} dimensions, got {len(embeddings[0])}")
        
        # Create embeddings dictionary
        embedding_dict = {}
        for verse_num, embedding in zip(verse_numbers, embeddings):
            embedding_dict[verse_num] = embedding.tolist()
        
        print(f"✅ Generated embeddings: {len(embedding_dict)} verses x {self.embedding_dimension} dimensions")
        return embedding_dict
    
    def save_data(self, verses: List[Dict[str, Any]], embeddings: Dict[str, List[float]]):
        """Save verse data and embeddings to JSON files"""
        
        # Ensure directories exist
        self.embeddings_path.parent.mkdir(parents=True, exist_ok=True)
        self.verses_path.parent.mkdir(parents=True, exist_ok=True)
        
        # Save verse metadata
        print(f"💾 Saving verse metadata to {self.verses_path}")
        with open(self.verses_path, 'w', encoding='utf-8') as f:
            json.dump(verses, f, indent=2, ensure_ascii=False)
        
        # Save embeddings
        print(f"💾 Saving embeddings to {self.embeddings_path}")
        with open(self.embeddings_path, 'w', encoding='utf-8') as f:
            json.dump(embeddings, f, indent=2)
        
        print("✅ Data saved successfully!")
        
        # Print statistics
        print("\n📊 Generation Statistics:")
        print(f"  • Total verses: {len(verses)}")
        print(f"  • Embedding dimensions: {self.embedding_dimension}")
        print(f"  • Model: all-MiniLM-L6-v2")
        print(f"  • File sizes:")
        print(f"    - Metadata: {self.verses_path.stat().st_size / 1024 / 1024:.1f} MB")
        print(f"    - Embeddings: {self.embeddings_path.stat().st_size / 1024 / 1024:.1f} MB")
    
    def generate_complete_dataset(self):
        """Main method to generate complete Quran embeddings dataset"""
        print("🚀 Starting Complete Quran Embeddings Generation")
        print("=" * 60)
        
        start_time = time.time()
        
        try:
            # Step 1: Fetch complete Quran
            verses = self.fetch_complete_quran()
            
            if not verses:
                print("❌ No verses fetched. Aborting.")
                return False
            
            # Step 2: Generate embeddings
            embeddings = self.generate_embeddings(verses)
            
            # Step 3: Save data
            self.save_data(verses, embeddings)
            
            # Success summary
            duration = time.time() - start_time
            print(f"\n🎉 Success! Complete dataset generated in {duration:.1f}s")
            print(f"   • Vector database now has {len(verses)} verses")
            print(f"   • Each embedding has {self.embedding_dimension} dimensions")
            print(f"   • Ready for 50-200ms semantic search!")
            
            return True
            
        except Exception as e:
            print(f"\n❌ Generation failed: {e}")
            return False


def main():
    generator = QuranEmbeddingGenerator()
    
    print("🌟 DuaCopilot - Complete Quran Embeddings Generator")
    print("This will generate embeddings for all 6,236+ verses of the Quran")
    print("Estimated time: 5-10 minutes")
    print()
    
    response = input("Continue? (y/N): ").strip().lower()
    if response != 'y':
        print("Aborted.")
        return
    
    success = generator.generate_complete_dataset()
    
    if success:
        print("\n🚀 Next Steps:")
        print("1. Restart your Flutter app")
        print("2. Try a query - it should now use fast vector search!")
        print("3. Look for 'Fast vector retrieval: X results in Y ms' in logs")
    else:
        print("\n💡 Troubleshooting:")
        print("- Check internet connection for API access")
        print("- Ensure Python packages are installed")
        print("- Try running again - API might have rate limits")


if __name__ == "__main__":
    main()

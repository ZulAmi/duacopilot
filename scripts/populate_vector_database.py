#!/usr/bin/env python3
"""
Vector Database Population Script for DuaCopilot
Fetches data from Quran API and Hadith API to create comprehensive embeddings
"""

import json
import os
import time
from typing import Dict, List, Tuple

import numpy as np
import requests
from sentence_transformers import SentenceTransformer


class VectorDatabasePopulator:
    def __init__(self):
        # API Configuration
        self.quran_api_base = "https://quranapi.pages.dev/api"
        
        # Model Configuration
        print("Loading SentenceTransformer model...")
        self.model = SentenceTransformer('all-MiniLM-L6-v2')
        print("Model loaded successfully!")
        
        # Output paths
        self.output_dir = "../assets/data"
        os.makedirs(self.output_dir, exist_ok=True)
        
        # Collections for different types of content
        self.quran_verses = []
        self.hadith_texts = []
    
    def fetch_quran_data(self) -> Dict:
        """Fetch all Quran chapters and verses"""
        print("Fetching Quran data...")
        
        # Get list of all surahs
        surah_list_url = f"{self.quran_api_base}/surah.json"
        response = requests.get(surah_list_url)
        response.raise_for_status()
        surahs = response.json()
        
        quran_data = {}
        verse_metadata = {}
        
        print(f"Found {len(surahs)} surahs. Fetching verses...")
        
        # Fetch all surahs (all 114 surahs for complete coverage)
        for i, surah in enumerate(surahs):  # Get ALL surahs, not just first 20
            surah_num = i + 1
            print(f"Fetching Surah {surah_num}: {surah['surahName']} ({surah['totalAyah']} verses)")
            
            # Get full surah data
            surah_url = f"{self.quran_api_base}/{surah_num}.json"
            try:
                surah_response = requests.get(surah_url)
                surah_response.raise_for_status()
                surah_data = surah_response.json()
                
                # Process each verse
                for verse_num, (arabic_text, english_text) in enumerate(zip(surah_data['arabic1'], surah_data['english']), 1):
                    verse_key = f"{surah_num}:{verse_num}"
                    
                    # Store verse metadata
                    verse_metadata[verse_key] = {
                        "surah": surah_num,
                        "verse": verse_num,
                        "surahName": surah['surahName'],
                        "surahNameArabic": surah['surahNameArabic'],
                        "surahNameTranslation": surah['surahNameTranslation'],
                        "arabicText": arabic_text,
                        "englishText": english_text,
                        "revelationPlace": surah['revelationPlace'],
                        "type": "quran"
                    }
                    
                    # Prepare text for embedding (combine English and some context)
                    embedding_text = f"Quran {surah['surahName']} {verse_num}: {english_text}"
                    self.quran_verses.append((verse_key, embedding_text))
                
                # Small delay to be respectful to API
                time.sleep(0.1)
                
            except Exception as e:
                print(f"Error fetching surah {surah_num}: {e}")
                continue
        
        print(f"Successfully fetched {len(self.quran_verses)} Quran verses")
        return verse_metadata
    
    def fetch_hadith_data(self) -> Dict:
        """Fetch Hadith data from fawazahmed0/hadith-api (much more comprehensive)"""
        print("Fetching Hadith data from comprehensive API...")
        
        hadith_metadata = {}
        
        # Major hadith collections with English and Arabic editions
        collections = [
            # Sahih al-Bukhari - most authentic
            {'collection': 'bukhari', 'lang': 'eng', 'name': 'Sahih al-Bukhari (English)', 'author': 'Muhsin Khan'},
            {'collection': 'bukhari', 'lang': 'ara', 'name': 'Sahih al-Bukhari (Arabic)', 'author': 'Unknown'},
            
            # Sahih Muslim - second most authentic  
            {'collection': 'muslim', 'lang': 'eng', 'name': 'Sahih Muslim (English)', 'author': 'Abdul Hamid Siddiqui'},
            {'collection': 'muslim', 'lang': 'ara', 'name': 'Sahih Muslim (Arabic)', 'author': 'Unknown'},
            
            # Forty Hadith an-Nawawi - essential collection
            {'collection': 'nawawi', 'lang': 'eng', 'name': 'Forty Hadith an-Nawawi (English)', 'author': 'Imam Nawawi'},
            {'collection': 'nawawi', 'lang': 'ara', 'name': 'Forty Hadith an-Nawawi (Arabic)', 'author': 'Imam Nawawi'},
            
            # Forty Hadith Qudsi - divine sayings
            {'collection': 'qudsi', 'lang': 'eng', 'name': 'Forty Hadith Qudsi (English)', 'author': 'Unknown'},
            {'collection': 'qudsi', 'lang': 'ara', 'name': 'Forty Hadith Qudsi (Arabic)', 'author': 'Unknown'},
            
            # Sunan Abu Dawud
            {'collection': 'abudawud', 'lang': 'eng', 'name': 'Sunan Abu Dawud (English)', 'author': 'Unknown'},
            
            # Jami At-Tirmidhi
            {'collection': 'tirmidhi', 'lang': 'eng', 'name': 'Jami At-Tirmidhi (English)', 'author': 'Unknown'},
        ]
        
        for collection_info in collections:
            collection_name = collection_info['collection']
            language = collection_info['lang']
            edition_name = f"{language}-{collection_name}"
            
            # Use the minified version for faster downloads
            url = f"https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions/{edition_name}.min.json"
            
            print(f"Fetching {collection_info['name']} from {url}")
            
            try:
                response = requests.get(url, timeout=60)
                if response.status_code == 200:
                    data = response.json()
                    
                    if 'hadiths' in data:
                        hadiths = data['hadiths']
                        print(f"Found {len(hadiths)} hadiths in {collection_info['name']}")
                        
                        # For initial dataset, limit per collection to manage size
                        limit = 50 if collection_name in ['bukhari', 'muslim'] else 40 if collection_name in ['nawawi', 'qudsi'] else 30
                        
                        for i, hadith in enumerate(hadiths[:limit]):
                            if isinstance(hadith, dict):
                                hadith_key = f"{collection_name}_{language}_{i+1}"
                                
                                # Extract text - try different possible field names
                                hadith_text = (
                                    hadith.get('text') or
                                    hadith.get('hadith') or
                                    hadith.get('body') or
                                    hadith.get('content') or
                                    str(hadith) if len(str(hadith)) > 50 else None
                                )
                                
                                if hadith_text and len(hadith_text.strip()) > 10:
                                    # Store hadith metadata
                                    hadith_metadata[hadith_key] = {
                                        "collection": collection_name,
                                        "language": language,
                                        "hadithNumber": hadith.get('hadithnumber', i+1),
                                        "arabicText": hadith_text if language == 'ara' else '',
                                        "englishText": hadith_text if language == 'eng' else '',
                                        "narrator": hadith.get('narrator', ''),
                                        "book": hadith.get('book', ''),
                                        "chapter": hadith.get('chapter', ''),
                                        "author": collection_info['author'],
                                        "type": "hadith"
                                    }
                                    
                                    # Prepare text for embedding
                                    embedding_text = f"Hadith from {collection_info['name']}: {hadith_text.strip()}"
                                    
                                    # Limit embedding text length
                                    if len(embedding_text) > 1000:
                                        embedding_text = embedding_text[:1000] + "..."
                                    
                                    self.hadith_texts.append((hadith_key, embedding_text))
                        
                        print(f"Processed {min(limit, len(hadiths))} hadiths from {collection_info['name']}")
                    else:
                        print(f"No 'hadiths' key found in {collection_info['name']}")
                        if isinstance(data, dict):
                            print(f"Available keys: {list(data.keys())}")
                        
                else:
                    print(f"Failed to fetch {collection_info['name']}: HTTP {response.status_code}")
                    
            except Exception as e:
                print(f"Error fetching {collection_info['name']}: {e}")
                continue
            
            # Progress indicator
            print(f"Current hadith count: {len(self.hadith_texts)}")
            
            # Limit total for initial dataset
            if len(self.hadith_texts) >= 500:
                print(f"Reached limit of 500 hadiths, stopping...")
                break
        
        print(f"Successfully fetched {len(self.hadith_texts)} Hadith texts from {len(set(h.split('_')[0] for h, _ in self.hadith_texts))} collections")
        return hadith_metadata
    
    def generate_embeddings(self, texts: List[Tuple[str, str]]) -> Dict[str, List[float]]:
        """Generate embeddings for a list of texts"""
        if not texts:
            return {}
        
        print(f"Generating embeddings for {len(texts)} texts...")
        
        # Extract just the texts for embedding
        text_list = [text for _, text in texts]
        keys = [key for key, _ in texts]
        
        # Generate embeddings in batches
        batch_size = 32
        all_embeddings = []
        
        for i in range(0, len(text_list), batch_size):
            batch_texts = text_list[i:i+batch_size]
            print(f"  Processing batch {i//batch_size + 1}/{(len(text_list) + batch_size - 1)//batch_size}")
            
            batch_embeddings = self.model.encode(batch_texts, convert_to_numpy=True)
            all_embeddings.extend(batch_embeddings)
        
        # Create embeddings dictionary
        embeddings_dict = {}
        for key, embedding in zip(keys, all_embeddings):
            embeddings_dict[key] = embedding.tolist()
        
        print(f"Generated {len(embeddings_dict)} embeddings with {len(all_embeddings[0])} dimensions")
        return embeddings_dict
    
    def save_data(self, quran_metadata: Dict, hadith_metadata: Dict, 
                  quran_embeddings: Dict, hadith_embeddings: Dict):
        """Save all data to files"""
        print("Saving data to files...")
        
        # Combine all metadata
        all_metadata = {**quran_metadata, **hadith_metadata}
        
        # Combine all embeddings
        all_embeddings = {**quran_embeddings, **hadith_embeddings}
        
        # Save comprehensive verse metadata
        metadata_file = os.path.join(self.output_dir, "comprehensive_islamic_texts.json")
        with open(metadata_file, 'w', encoding='utf-8') as f:
            json.dump(all_metadata, f, ensure_ascii=False, indent=2)
        
        # Save comprehensive embeddings
        embeddings_file = os.path.join(self.output_dir, "comprehensive_islamic_embeddings.json")
        with open(embeddings_file, 'w', encoding='utf-8') as f:
            json.dump(all_embeddings, f, indent=2)
        
        # Also update the existing files for compatibility
        quran_verses_file = os.path.join(self.output_dir, "quran_verses_min.json")
        with open(quran_verses_file, 'w', encoding='utf-8') as f:
            json.dump(quran_metadata, f, ensure_ascii=False, indent=2)
        
        quran_embeddings_file = os.path.join(self.output_dir, "quran_embeddings_minilm.json")
        with open(quran_embeddings_file, 'w', encoding='utf-8') as f:
            json.dump(quran_embeddings, f, indent=2)
        
        print(f"Data saved successfully!")
        print(f"  Total texts: {len(all_metadata)}")
        print(f"  Quran verses: {len(quran_metadata)}")
        print(f"  Hadith texts: {len(hadith_metadata)}")
        print(f"  Embeddings dimension: {len(list(all_embeddings.values())[0]) if all_embeddings else 0}")
    
    def run(self):
        """Main execution function"""
        print("Starting Vector Database Population...")
        print("=" * 60)
        
        try:
            # Fetch data from APIs
            quran_metadata = self.fetch_quran_data()
            hadith_metadata = self.fetch_hadith_data()
            
            # Generate embeddings
            quran_embeddings = self.generate_embeddings(self.quran_verses)
            hadith_embeddings = self.generate_embeddings(self.hadith_texts)
            
            # Save everything
            self.save_data(quran_metadata, hadith_metadata, quran_embeddings, hadith_embeddings)
            
            print("=" * 60)
            print("✅ Vector Database Population Complete!")
            print(f"📊 Summary:")
            print(f"   • Quran verses: {len(quran_metadata)}")
            print(f"   • Hadith texts: {len(hadith_metadata)}")
            print(f"   • Total embeddings: {len(quran_embeddings) + len(hadith_embeddings)}")
            print(f"   • Files created in: {self.output_dir}")
            
        except Exception as e:
            print(f"❌ Error during population: {e}")
            raise

if __name__ == "__main__":
    populator = VectorDatabasePopulator()
    populator.run()

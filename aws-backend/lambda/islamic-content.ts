// Islamic Content Lambda Functions
import { getDuasByCategory, searchQuranVerses } from './shared/helpers';
import { HttpsError, lambdaWrapper } from './shared/lambda-adapter';

export const getDuas = lambdaWrapper(async (data: any, context: any) => {
  const { category, emotion, context: duaContext, language = 'en', limit = 20 } = data;
  
  try {
    // Get duas by category (this would be populated from Islamic database)
    const duas = await getDuasByCategory(category, language);
    
    return { duas };
  } catch (error) {
    console.error('Error getting duas:', error);
    throw new HttpsError('internal', 'Failed to get duas');
  }
});

export const searchQuran = lambdaWrapper(async (data: any, context: any) => {
  const { query, language = 'en', limit = 10 } = data;
  
  try {
    // Search Quran verses
    const verses = await searchQuranVerses(query, language);
    
    return { verses };
  } catch (error) {
    console.error('Error searching Quran:', error);
    throw new HttpsError('internal', 'Failed to search Quran');
  }
});

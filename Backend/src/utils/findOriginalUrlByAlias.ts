import UrlModel from '../models/Url';

export default async function findOriginalUrlByAlias(alias: string): Promise<string | null> {
  const doc = await UrlModel.findOne({ alias });
  return doc ? doc.originalUrl : null;
} 
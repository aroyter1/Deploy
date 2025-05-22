import mongoose from 'mongoose';

const urlSchema = new mongoose.Schema({
  alias: { type: String, required: true, unique: true },
  originalUrl: { type: String, required: true },
});

const UrlModel = mongoose.model('Url', urlSchema);
export default UrlModel; 
"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const client_s3_1 = require("@aws-sdk/client-s3");
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
const app = (0, express_1.default)();
app.use(express_1.default.json());
const s3Client = new client_s3_1.S3Client({ region: process.env.AWS_REGION || 'ap-south-1' });
const BUCKET_NAME = process.env.S3_BUCKET_NAME;
if (!BUCKET_NAME) {
    throw new Error('S3_BUCKET_NAME environment variable is required');
}
app.get('/list-bucket-content/:path(*)?', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const path = req.params.path || '';
        const prefix = path ? `${path}/` : '';
        const command = new client_s3_1.ListObjectsV2Command({
            Bucket: BUCKET_NAME,
            Prefix: prefix,
            Delimiter: '/'
        });
        const response = yield s3Client.send(command);
        // Get folders (from CommonPrefixes)
        const folders = (response.CommonPrefixes || [])
            .map(prefix => {
            var _a;
            return ({
                name: ((_a = prefix.Prefix) === null || _a === void 0 ? void 0 : _a.slice(0, -1).split('/').pop()) || '',
                type: 'folder'
            });
        });
        // Get files (from Contents)
        const files = (response.Contents || [])
            .filter(file => file.Key !== prefix)
            .map(file => {
            var _a;
            return ({
                name: ((_a = file.Key) === null || _a === void 0 ? void 0 : _a.split('/').pop()) || '',
                type: 'file'
            });
        });
        // Combine folders and files, filter out empty names
        const content = [...folders, ...files].filter(item => item.name !== '');
        res.json({ content });
    }
    catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            error: 'No Object named that path or Failed to list bucket contents'
        });
    }
}));
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
exports.default = app;

import express, { Request, Response } from 'express';
import { S3Client, ListObjectsV2Command } from '@aws-sdk/client-s3';
import dotenv from 'dotenv'

dotenv.config()
const app = express();
app.use(express.json());



const s3Client = new S3Client({ region: process.env.AWS_REGION || 'ap-south-1' });
const BUCKET_NAME = process.env.S3_BUCKET_NAME;

if (!BUCKET_NAME) {
    throw new Error('S3_BUCKET_NAME environment variable is required');
}

app.get('/list-bucket-content/:path(*)?', async (req: Request, res: Response) => {
    try {
        const path = req.params.path || '';
        const prefix = path ? `${path}/` : '';

        const command = new ListObjectsV2Command({
            Bucket: BUCKET_NAME,
            Prefix: prefix,
            Delimiter: '/'
        });

        const response = await s3Client.send(command);

        // Get folders (from CommonPrefixes)
        const folders = (response.CommonPrefixes || [])
            .map(prefix => ({
                name: prefix.Prefix?.slice(0, -1).split('/').pop() || '',
                type: 'folder' as const
            }));

        // Get files (from Contents)
        const files = (response.Contents || [])
            .filter(file => file.Key !== prefix)
            .map(file => ({
                name: file.Key?.split('/').pop() || '',
                type: 'file' as const
            }));

        // Combine folders and files, filter out empty names
        const content = [...folders, ...files].filter(item => item.name !== '');
        if (content.length == 0) {
            res.status(400).json({
                message: "Empty Directory/folder or No such Directory/folder", prefix
            })
        }
        res.json({ content });
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ 
            error: 'Failed to list bucket contents',
            details: error instanceof Error ? error.message :"Might not have permission"
        });
    }
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

export default app;

interface S3Item {
    name: string;
    type: 'file' | 'folder';
}

export interface BucketListResponse {
    content: S3Item[];
}

export interface ErrorResponse {
    error: string;
    details?: string;
}
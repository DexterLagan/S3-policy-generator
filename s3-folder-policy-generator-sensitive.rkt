#lang racket/gui

;;; purpose

; to generate a sensitive sub-user S3/Wasabi policy (JSON)

;;; defs

(define appname "Sensitive S3 Policy Generator")

(define policy-template
  "{
    \"Version\":\"2012-10-17\",
    \"Statement\": [
        {
            \"Effect\": \"Allow\",
            \"Action\": [
                \"s3:GetObject\",
                \"s3:PutObject\",
                \"s3:GetObjectAcl\",
                \"s3:PutObjectAcl\",
                \"s3:ListBucket\",
                \"s3:GetBucketAcl\",
                \"s3:PutBucketAcl\",
                \"s3:GetBucketLocation\"
            ],
            \"Resource\": \"arn:aws:s3:::<BUCKET-NAME>/*\",
            \"Condition\": {}
        },
        {
            \"Effect\": \"Allow\",
            \"Action\": \"s3:ListAllMyBuckets\",
            \"Resource\": \"*\",
            \"Condition\": {}
        }
    ]
}")

;;; main

(define bucket-name (get-text-from-user appname "Please enter the bucket name:"))
(when (or (not bucket-name) (string=? bucket-name "")) (exit 0))

(let* ((final-policy (string-replace policy-template "<BUCKET-NAME>" bucket-name)))
  (void (message-box appname final-policy)))


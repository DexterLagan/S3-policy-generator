#lang racket/gui

;;; purpose

; to generate a per-folder/user S3/Wasabi policy (JSON)

;;; defs

(require racket/date)
(define appname "Folder-level S3 Policy Generator")
(define policy-template
  "{
 \"Version\":\"2012-10-17\",
 \"Statement\": [
 {
 \"Sid\": \"AllowListingOfUserFolder\",
 \"Action\": [\"s3:ListBucket\"],
 \"Effect\": \"Allow\",
 \"Resource\": [\"arn:aws:s3:::<BUCKET-NAME>\"],
 \"Condition\":{\"StringLike\":{\"s3:prefix\":[\"<USER-FOLDER-NAME-INSIDE-BUCKET>/*\"]}}
 },
 {
 \"Sid\": \"AllowAllS3ActionsInUserFolder\",
 \"Effect\": \"Allow\",
 \"Action\": [\"s3:*\"],
 \"Resource\": [\"arn:aws:s3:::<BUCKET-NAME>/<USER-FOLDER-NAME-INSIDE-BUCKET>/*\"]
 }
 ]
}")

;;; main

(define bucket-name (get-text-from-user appname "Please enter the bucket name:"))
(when (or (string=? bucket-name "") (not bucket-name)) (exit 0))

(define user-folder-name (get-text-from-user appname "Please enter the user folder name:"))
(when (or (string=? user-folder-name "") (not user-folder-name)) (exit 0))

(let* ((bucket-policy (string-replace policy-template "<BUCKET-NAME>" bucket-name))
       (final-policy (string-replace bucket-policy "<USER-FOLDER-NAME-INSIDE-BUCKET>" user-folder-name)))
  (void (message-box appname final-policy)))


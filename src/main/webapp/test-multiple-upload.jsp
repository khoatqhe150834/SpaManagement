<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Multiple Image Upload</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .upload-area {
            border: 2px dashed #ccc;
            border-radius: 8px;
            padding: 40px;
            text-align: center;
            margin: 20px 0;
            background: #f9f9f9;
        }
        .upload-area:hover {
            border-color: #007bff;
            background: #f0f8ff;
        }
        .file-list {
            margin: 20px 0;
        }
        .file-item {
            padding: 10px;
            border: 1px solid #ddd;
            margin: 5px 0;
            border-radius: 4px;
            background: white;
        }
        .progress {
            width: 100%;
            height: 20px;
            background: #f0f0f0;
            border-radius: 10px;
            overflow: hidden;
            margin: 10px 0;
        }
        .progress-bar {
            height: 100%;
            background: #007bff;
            width: 0%;
            transition: width 0.3s ease;
        }
        .result {
            margin: 20px 0;
            padding: 15px;
            border-radius: 4px;
        }
        .success { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; }
        .error { background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }
        .warning { background: #fff3cd; border: 1px solid #ffeaa7; color: #856404; }
        button {
            background: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background: #0056b3;
        }
        button:disabled {
            background: #6c757d;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <h1>Test Multiple Image Upload</h1>
    <p>This page tests the multiple image upload functionality for service images.</p>
    
    <div>
        <label for="serviceId">Service ID:</label>
        <input type="number" id="serviceId" value="1" min="1" style="padding: 8px; margin: 10px;">
        <small>Enter the ID of the service to upload images for</small>
    </div>
    
    <div class="upload-area" id="uploadArea">
        <h3>Drop multiple images here or click to select</h3>
        <p>Supported formats: JPG, PNG, WebP (max 2MB each)</p>
        <input type="file" id="fileInput" multiple accept="image/*" style="display: none;">
        <button type="button" onclick="document.getElementById('fileInput').click()">
            Choose Files
        </button>
    </div>
    
    <div id="fileList" class="file-list" style="display: none;">
        <h3>Selected Files:</h3>
        <div id="fileItems"></div>
        <button id="uploadBtn" onclick="uploadFiles()" style="margin-top: 15px;">
            Upload All Files
        </button>
    </div>
    
    <div id="uploadProgress" style="display: none;">
        <h3>Upload Progress:</h3>
        <div id="progressItems"></div>
    </div>
    
    <div id="results"></div>
    
    <script>
        const contextPath = '${pageContext.request.contextPath}';
        let selectedFiles = [];
        
        // Set up drag and drop
        const uploadArea = document.getElementById('uploadArea');
        const fileInput = document.getElementById('fileInput');
        
        uploadArea.addEventListener('dragover', (e) => {
            e.preventDefault();
            uploadArea.style.borderColor = '#007bff';
            uploadArea.style.background = '#f0f8ff';
        });
        
        uploadArea.addEventListener('dragleave', () => {
            uploadArea.style.borderColor = '#ccc';
            uploadArea.style.background = '#f9f9f9';
        });
        
        uploadArea.addEventListener('drop', (e) => {
            e.preventDefault();
            uploadArea.style.borderColor = '#ccc';
            uploadArea.style.background = '#f9f9f9';
            
            const files = Array.from(e.dataTransfer.files);
            handleFileSelection(files);
        });
        
        uploadArea.addEventListener('click', () => {
            fileInput.click();
        });
        
        fileInput.addEventListener('change', (e) => {
            const files = Array.from(e.target.files);
            handleFileSelection(files);
        });
        
        function handleFileSelection(files) {
            selectedFiles = files.filter(file => {
                const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
                return validTypes.includes(file.type) && file.size <= 2 * 1024 * 1024;
            });
            
            if (selectedFiles.length === 0) {
                showResult('No valid files selected. Please select JPG, PNG, or WebP files under 2MB.', 'error');
                return;
            }
            
            displaySelectedFiles();
        }
        
        function displaySelectedFiles() {
            const fileList = document.getElementById('fileList');
            const fileItems = document.getElementById('fileItems');
            
            fileItems.innerHTML = '';
            
            selectedFiles.forEach((file, index) => {
                const item = document.createElement('div');
                item.className = 'file-item';
                item.innerHTML = `
                    <strong>${file.name}</strong> 
                    (${(file.size / 1024).toFixed(1)} KB)
                `;
                fileItems.appendChild(item);
            });
            
            fileList.style.display = 'block';
            document.getElementById('uploadBtn').disabled = false;
        }
        
        function uploadFiles() {
            const serviceId = document.getElementById('serviceId').value;
            if (!serviceId || serviceId < 1) {
                showResult('Please enter a valid service ID', 'error');
                return;
            }
            
            const formData = new FormData();
            formData.append('serviceId', serviceId);
            
            selectedFiles.forEach(file => {
                formData.append('images', file);
            });
            
            // Show progress
            showProgress();
            document.getElementById('uploadBtn').disabled = true;
            
            // Upload
            fetch(contextPath + '/manager/service-images/upload-single', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                handleUploadResponse(data);
            })
            .catch(error => {
                console.error('Upload error:', error);
                showResult('Upload failed: ' + error.message, 'error');
                document.getElementById('uploadBtn').disabled = false;
            });
        }
        
        function showProgress() {
            const progressDiv = document.getElementById('uploadProgress');
            const progressItems = document.getElementById('progressItems');
            
            progressItems.innerHTML = '';
            
            selectedFiles.forEach((file, index) => {
                const item = document.createElement('div');
                item.innerHTML = `
                    <div style="margin-bottom: 10px;">
                        <div><strong>${file.name}</strong></div>
                        <div class="progress">
                            <div class="progress-bar" id="progress-${index}"></div>
                        </div>
                        <div id="status-${index}">Uploading...</div>
                    </div>
                `;
                progressItems.appendChild(item);
            });
            
            progressDiv.style.display = 'block';
            
            // Simulate progress
            selectedFiles.forEach((file, index) => {
                const progressBar = document.getElementById(`progress-${index}`);
                let width = 0;
                const interval = setInterval(() => {
                    width += 10;
                    progressBar.style.width = width + '%';
                    if (width >= 90) {
                        clearInterval(interval);
                    }
                }, 100);
            });
        }
        
        function handleUploadResponse(data) {
            console.log('Upload response:', data);
            
            // Update progress bars
            selectedFiles.forEach((file, index) => {
                const progressBar = document.getElementById(`progress-${index}`);
                const status = document.getElementById(`status-${index}`);
                
                progressBar.style.width = '100%';
                
                if (data.results && data.results[index]) {
                    const result = data.results[index];
                    if (result.success) {
                        status.textContent = 'Success';
                        status.style.color = 'green';
                    } else {
                        status.textContent = 'Failed: ' + (result.error || 'Unknown error');
                        status.style.color = 'red';
                        progressBar.style.background = 'red';
                    }
                } else {
                    status.textContent = data.success ? 'Success' : 'Failed';
                    status.style.color = data.success ? 'green' : 'red';
                    if (!data.success) {
                        progressBar.style.background = 'red';
                    }
                }
            });
            
            // Show overall result
            let resultType = 'success';
            if (data.errorCount > 0 && data.successCount > 0) {
                resultType = 'warning';
            } else if (data.errorCount > 0) {
                resultType = 'error';
            }
            
            showResult(data.message || 'Upload completed', resultType);
            
            // Re-enable upload button
            setTimeout(() => {
                document.getElementById('uploadBtn').disabled = false;
            }, 3000);
        }
        
        function showResult(message, type) {
            const results = document.getElementById('results');
            results.innerHTML = `<div class="result ${type}">${message}</div>`;
        }
    </script>
</body>
</html>

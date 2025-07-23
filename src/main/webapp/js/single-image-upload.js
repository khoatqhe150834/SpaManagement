// single-image-upload.js
// This script handles image upload management for the SingleImageUpload.jsp page.
// It expects two global variables to be defined BEFORE loading:
//   window.contextPath – the web application context path
//   window.serviceId   – the numeric ID of the service being edited

(function() {
    'use strict';

    // Ensure required globals exist
    const contextPath = window.contextPath || '';
    const serviceId = window.serviceId;

    if (serviceId == null) {
        console.error('single-image-upload.js: serviceId is not defined');
        return;
    }

    // ---------------------------------------------------------------------
    // Lucide fallback (prevent ReferenceError if lucide is absent)
    // ---------------------------------------------------------------------
    if (typeof window.lucide === 'undefined') {
        window.lucide = {
            createIcons: function() {
                // noop
                console.log('Lucide not available, using fallback');
            }
        };
    }

    // ---------------------------------------------------------------------
    // Helper: toast / alert style messages
    // ---------------------------------------------------------------------
    function showMessage(message, type) {
        const resultsDiv  = document.getElementById('uploadResults');
        const successDiv  = document.getElementById('successMessage');
        const errorDiv    = document.getElementById('errorMessage');

        if (!resultsDiv || !successDiv || !errorDiv) {
            console.error('single-image-upload.js: message containers not found');
            alert(message);
            return;
        }

        resultsDiv.style.display = 'block';

        if (type === 'success') {
            successDiv.textContent = message;
            successDiv.style.display = 'block';
            successDiv.className = 'alert alert-success';
            errorDiv.style.display = 'none';
        } else if (type === 'warning') {
            successDiv.textContent = message;
            successDiv.style.display = 'block';
            successDiv.className = 'alert alert-warning';
            errorDiv.style.display = 'none';
        } else {
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
            successDiv.style.display = 'none';
        }

        // Auto-hide
        const delay = type === 'success' ? 5000 : 7000;
        setTimeout(() => { resultsDiv.style.display = 'none'; }, delay);
    }

    // Expose globally for other scripts / inline handlers
    window.showMessage = showMessage;

    // ---------------------------------------------------------------------
    // Actions: set primary, delete, refresh
    // ---------------------------------------------------------------------
    function setPrimaryImage(imageId) {
        if (!imageId) {
            showMessage('Missing image ID', 'error');
            return;
        }

        fetch(`${contextPath}/manager/service-images/set-primary`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `imageId=${encodeURIComponent(imageId)}&serviceId=${encodeURIComponent(serviceId)}`
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                // Cập nhật UI ngay lập tức
                document.querySelectorAll('.image-preview-item').forEach(function(item) {
                    const badge = item.querySelector('.primary-badge');
                    const starBtn = item.querySelector('.star-btn');
                    if (badge) badge.classList.add('hidden');
                    if (starBtn) starBtn.classList.remove('hidden');
                });
                // Ẩn nút star và hiện badge cho ảnh vừa chọn
                const container = document.querySelector(`.image-preview-item[data-image-id="${imageId}"]`);
                if (container) {
                    const badge = container.querySelector('.primary-badge');
                    const starBtn = container.querySelector('.star-btn');
                    if (badge) badge.classList.remove('hidden');
                    if (starBtn) starBtn.classList.add('hidden');
                }
                showMessage('Đã đổi ảnh chính thành công!', 'success');
            } else {
                showMessage('Failed to set primary image: ' + (data.error || 'Unknown error'), 'error');
            }
        })
        .catch(err => {
            console.error(err);
            showMessage('Error: ' + err.message, 'error');
        });
    }

    function deleteImage(imageId) {
        if (!imageId) return;
        if (!confirm('Are you sure you want to delete this image?')) return;

        fetch(`${contextPath}/manager/service-images/delete`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `imageId=${encodeURIComponent(imageId)}&serviceId=${encodeURIComponent(serviceId)}`
        })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                showMessage('Image deleted successfully!', 'success');
                setTimeout(refreshImages, 1500);
            } else {
                showMessage('Failed to delete image: ' + (data.error || 'Unknown error'), 'error');
            }
        })
        .catch(err => {
            console.error(err);
            showMessage('Error: ' + err.message, 'error');
        });
    }

    function refreshImages() {
        window.location.reload();
    }

    // Attach to window for inline onclick references
    window.setPrimaryImage = setPrimaryImage;
    window.deleteImage    = deleteImage;
    window.refreshImages  = refreshImages;

    // ---------------------------------------------------------------------
    // DOM-related utilities
    // ---------------------------------------------------------------------
    function createProgressItem(fileName, index) {
        const item = document.createElement('div');
        item.className = 'progress-item';
        item.innerHTML = `
            <div style="min-width:150px;"><small class="fw-semibold">${fileName}</small></div>
            <div class="progress-bar"><div class="progress-fill" id="progress-${index}"></div></div>
            <small class="text-muted" id="status-${index}">Uploading...</small>`;
        return item;
    }

    function handleUploadResponse(data) {
        const uploadProgress = document.getElementById('uploadProgress');

        if (data.success) {
            showMessage(data.message || 'Images uploaded successfully!', 'success');
        } else if (data.successCount > 0) {
            showMessage(data.message || 'Some uploads failed', 'warning');
        } else {
            showMessage(data.message || 'Upload failed', 'error');
        }

        if (Array.isArray(data.results)) {
            data.results.forEach((result, idx) => {
                const bar   = document.getElementById(`progress-${idx}`);
                const label = document.getElementById(`status-${idx}`);
                if (!bar || !label) return;
                bar.style.width = '100%';
                if (result.success) {
                    label.textContent = 'Complete';
                    label.className   = 'text-success';
                } else {
                    bar.style.background = '#dc3545';
                    label.textContent = result.error || 'Failed';
                    label.className   = 'text-danger';
                }
            });
        }

        const delay = data.successCount > 0 ? 3000 : 5000;
        setTimeout(() => {
            uploadProgress.style.display = 'none';
            if (data.successCount > 0) refreshImages();
        }, delay);
    }

    const MAX_SIZE = 2 * 1024 * 1024; // 2 MB – should match server-side validateFile

    function handleFileUpload(files) {
        if (!files.length) return;

        // Client-side size validation before hitting network
        const tooLarge = files.find(f => f.size > MAX_SIZE);
        if (tooLarge) {
            showMessage(`"${tooLarge.name}" is ${(tooLarge.size/1024/1024).toFixed(2)} MB — max allowed is 2 MB`, 'error');
            return;
        }

        const progressContainer = document.getElementById('progressContainer');
        const uploadProgress    = document.getElementById('uploadProgress');
        uploadProgress.style.display = 'block';
        progressContainer.innerHTML  = '';

        const formData = new FormData();
        formData.append('serviceId', serviceId);

        files.forEach((file, idx) => {
            formData.append('images', file);
            progressContainer.appendChild(createProgressItem(file.name, idx));
        });

        fetch(`${contextPath}/manager/service-images/upload-single`, { method:'POST', body: formData })
            .then(r => {
                if (!r.ok) {
                    return r.text().then(txt => {
                        throw new Error(`${r.status} ${r.statusText}`);
                    });
                }
                return r.json();
            })
            .then(handleUploadResponse)
            .catch(err => { console.error(err); showMessage('Upload failed: ' + err.message, 'error'); });
    }

    function updateImageOrder() {
        const items    = document.querySelectorAll('.image-preview-item');
        const imageIds = Array.from(items).map(i => i.dataset.imageId);
        if (!imageIds.length) return;

        fetch(`${contextPath}/manager/service-images/update-order`, {
            method:'POST',
            headers:{ 'Content-Type':'application/x-www-form-urlencoded' },
            body:`order=${imageIds.join(',')}`
        })
        .then(r=>r.json())
        .then(d=>{
            if(d.success){ showMessage('Image order updated successfully!', 'success'); }
            else          { showMessage('Failed to update order: '+(d.error||'Unknown'), 'error'); }
        })
        .catch(err=>{ console.error(err); showMessage('Error updating order: '+err.message,'error'); });
    }

    // ---------------------------------------------------------------------
    // DOM Ready initialisation
    // ---------------------------------------------------------------------
    document.addEventListener('DOMContentLoaded', function() {
        const uploadZone  = document.getElementById('uploadZone');
        const imageInput  = document.getElementById('imageInput');

        if (uploadZone && imageInput) {
            uploadZone.addEventListener('dragover', e => { e.preventDefault(); uploadZone.classList.add('dragover'); });
            uploadZone.addEventListener('dragleave', () => uploadZone.classList.remove('dragover'));
            uploadZone.addEventListener('drop', async e => {
                e.preventDefault();
                uploadZone.classList.remove('dragover');

                const fileList = Array.from(e.dataTransfer.files);
                if (fileList.length) {
                    handleFileUpload(fileList);
                    return;
                }

                // No files – maybe a dragged image URL or HTML snippet
                let url = e.dataTransfer.getData('text/uri-list');
                if (!url) {
                    const html = e.dataTransfer.getData('text/html');
                    if (html) {
                        const match = html.match(/<img[^>]*src=["']?([^"'>]+)["']?/i);
                        if (match && match[1]) url = match[1];
                    }
                }

                if (!url) {
                    showMessage('Could not detect an image in the dragged data.', 'error');
                    return;
                }

                try {
                    const fetchedFile = await fetchImageAsFile(url);
                    handleFileUpload([fetchedFile]);
                } catch (err) {
                    console.error(err);
                    showMessage('Unable to fetch dragged image: ' + err.message, 'error');
                }
            });
            // Only trigger file dialog when the zone itself (not its children) is clicked
            uploadZone.addEventListener('click', e => {
                if (e.target === uploadZone) {
                    imageInput.click();
                }
            });

            imageInput.addEventListener('change', e => handleFileUpload(Array.from(e.target.files)));
        }

        // Handle dedicated choose button without bubbling to zone
        const chooseBtn = document.getElementById('chooseFilesBtn');
        if (chooseBtn) {
            chooseBtn.addEventListener('click', e => {
                e.stopPropagation();
                imageInput.click();
            });
        }

        // Sortable
        const existingImages = document.getElementById('existingImagesContainer');
        if (existingImages && typeof Sortable !== 'undefined') {
            new Sortable(existingImages, { animation: 150, ghostClass: 'sortable-placeholder', onEnd:updateImageOrder });
        }

        console.log('single-image-upload.js initialised');
    });

    // helper to fetch external image and turn into File
    async function fetchImageAsFile(url) {
        const response = await fetch(url, { mode: 'cors' });
        if (!response.ok) throw new Error(response.status + ' ' + response.statusText);
        const blob = await response.blob();
        // Guess filename from URL
        const name = url.split('/').pop().split('?')[0] || 'dragged-image';
        const file = new File([blob], name, { type: blob.type });
        return file;
    }

})(); 
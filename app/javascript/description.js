function setupPreviewButtons() {
 document.querySelectorAll('.preview-btn').forEach(button => {
   button.addEventListener('click', handlePreviewClick);
 });
}

function handlePreviewClick() {
 const urlInput = this.previousElementSibling;
 const url = urlInput.value;
 const previewContainer = this.closest('.event-item').querySelector('.preview-container');

 if (!url) {
   showPreviewMessage(previewContainer, '<p>URLを入力してください。</p>');
   return;
 }

 fetch(`/preview_description?url=${encodeURIComponent(url)}`)
   .then(response => response.json())
   .then(data => {
     if (data.error) {
       showPreviewMessage(previewContainer, `<p>エラー: ${data.error}</p>`);
     } else {
       showPreviewMessage(previewContainer, `<p>プレビュー: ${data.description}</p>`);
     }
   })
   .catch(error => {
     console.error('エラー:', error);
     showPreviewMessage(previewContainer, '<p>説明の取得に失敗しました。</p>');
   });
}

function showPreviewMessage(container, message) {
 container.innerHTML = `${message}<button class="close-preview-btn">閉じる</button>`;
 container.style.display = 'block';
}

function setupClosePreviewButtons() {
 document.addEventListener('click', function(e) {
   if (e.target && e.target.classList.contains('close-preview-btn')) {
     const previewContainer = e.target.closest('.preview-container');
     if (previewContainer) {
       previewContainer.style.display = 'none';
     }
   }
 });
}

function initializePreviewFunctionality() {
 setupPreviewButtons();
 setupClosePreviewButtons();
}

window.addEventListener('turbo:load', initializePreviewFunctionality);
window.addEventListener('turbo:render', initializePreviewFunctionality);
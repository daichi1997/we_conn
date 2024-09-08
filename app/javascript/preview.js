document.addEventListener('turbo:load', function(){
 const imageForm = document.querySelector('.image_form');
 const previewList = document.getElementById('previews');

 if (!imageForm) return null;

 console.log("preview.jsが読み込まれました");

 const fileField = document.querySelector('.form-control-file');

 fileField.addEventListener('change', function(e){
   console.log("ファイルが選択されました");

   const alreadyPreview = document.querySelector('.preview');
   if (alreadyPreview) {
     alreadyPreview.remove();
   }

   const file = e.target.files[0];
   const blob = window.URL.createObjectURL(file);

   const previewWrapper = document.createElement('div');
   previewWrapper.setAttribute('class', 'preview');

   const previewImage = document.createElement('img');
   previewImage.setAttribute('class', 'preview-image');
   previewImage.setAttribute('src', blob);

   // プレビュー画像のサイズを制限
   previewImage.style.maxWidth = '300px';  // 最大幅を300pxに設定
   previewImage.style.maxHeight = '300px'; // 最大高さを300pxに設定
   previewImage.style.width = 'auto';      // 幅を自動調整
   previewImage.style.height = 'auto';     // 高さを自動調整

   previewWrapper.appendChild(previewImage);
   previewList.appendChild(previewWrapper);

   const existingImage = document.querySelector('#image-container .event-image img');
   if (existingImage) {
     existingImage.style.display = 'none';
   }

   const removeButton = document.querySelector('input[name="remove_image"]');
   if (removeButton) {
     removeButton.style.display = 'inline-block';
   }
 });

 // 「画像を削除」ボタンのクリックイベント
 const removeButton = document.querySelector('input[name="remove_image"]');
 if (removeButton) {
   removeButton.addEventListener('click', function(e) {
     e.preventDefault();
     
     const preview = document.querySelector('.preview');
     if (preview) {
       preview.remove();
     }

     fileField.value = '';

     const existingImage = document.querySelector('#image-container .event-image img');
     if (existingImage) {
       existingImage.style.display = 'block';
     }

     this.style.display = 'none';
   });
 }
});
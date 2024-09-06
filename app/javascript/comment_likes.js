document.addEventListener('turbolinks:load', function() {
 document.querySelectorAll('.owner-like-button').forEach(function(button) {
   button.addEventListener('ajax:success', function(event) {
     const [data, status, xhr] = event.detail;
     const commentId = this.dataset.commentId;
     const likeStatus = document.getElementById(`owner-like-status-${commentId}`);
     if (data.liked) {
       this.textContent = 'いいね取り消し';
       likeStatus.textContent = '投稿者からいいねされています';
     } else {
       this.textContent = 'いいね';
       likeStatus.textContent = '';
     }
   });
 });
});
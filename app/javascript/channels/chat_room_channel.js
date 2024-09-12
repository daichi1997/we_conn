import consumer from "../channels/consumer"

function setupChatRoom() {
  const element = document.getElementById('messages')
  if (element) {
    const chatRoomId = element.getAttribute('data-chat-room-id')

    if (window.chatSubscription) {
      window.chatSubscription.unsubscribe()
    }

    window.chatSubscription = consumer.subscriptions.create(
      { channel: "ChatRoomChannel", room_id: chatRoomId },
      {
        connected() {
          console.log("Connected to ChatRoomChannel")
        },

        disconnected() {
          console.log("Disconnected from ChatRoomChannel")
        },

        received(data) {
          element.insertAdjacentHTML('beforeend', data['message'])
        }
      }
    )
  }
}

function setupFormReset() {
  const form = document.getElementById('message-form')
  if (form) {
    form.addEventListener('turbo:submit-end', function(event) {
      form.reset() // フォームをリセット
    })
  }
}

function initializeChatAndForm() {
  setupChatRoom()
  setupFormReset()
}

window.addEventListener('turbo:load', initializeChatAndForm)
window.addEventListener('turbo:render', initializeChatAndForm)
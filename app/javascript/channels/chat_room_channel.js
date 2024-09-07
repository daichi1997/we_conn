import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById('messages')
  if (element) {
    const chat_room_id = element.getAttribute('data-chat-room-id')

    consumer.subscriptions.create({ channel: "ChatRoomChannel", room_id: chat_room_id }, {
      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        element.insertAdjacentHTML('beforeend', data['message'])
      }
    })
  }
})
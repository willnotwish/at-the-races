document.addEventListener("DOMContentLoaded", (event) => {
  const appendDiv = (container, content) => {
    const div = document.createElement('div');
    div.append(content);
    container.append(div);
  }

  const container = document.getElementById("race_running_container");

  if (container) {
    console.log('DOM loaded. race_running_container detected.');

    const printHeaders = () => {
      const timeToken = document.createElement('div');
      timeToken.append('Elapsed time (us)');

      const id = document.createElement('div');
      id.append('Event type');

      const text = document.createElement('div');
      text.append('Text');

      const pid = document.createElement('div');
      pid.append('Process ID');

      container.append(timeToken);
      container.append(id);
      container.append(text);
      container.append(pid);
    }

    const elapsedTimeFormatter = new Intl.NumberFormat("en-GB");

    let startTime;
    const messageProcessor = (event) => {
      let elapsedTime = false;
      
      const message = event.message;
      if (message.id == 'driver.start' && !startTime) {
        startTime = event.timetoken;
      }

      if (startTime) {
        elapsedTime = (event.timetoken - startTime)/10000.0;
      }

      console.log("Received message: ", elapsedTime, message.id, message.payload);

      appendDiv(container, elapsedTimeFormatter.format(elapsedTime));
      appendDiv(container, message.id);
      appendDiv(container, message.payload.text);
      appendDiv(container, message.payload.pid);
    }

    printHeaders();
    
    const client = new PubNub({
      subscribeKey: container.dataset.pubnubSubscribeKey,
      userId: container.dataset.pubnubUserId
    });

    const subscription = client
      .channel(container.dataset.pubnubChannel)
      .subscription({ receivePresenceEvents: false });
    
    subscription.addListener({ message: messageProcessor });
    subscription.subscribe();

    console.log('Listening for pubnub messages...');
  }
});

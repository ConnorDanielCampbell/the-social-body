import com.temboo.core.*;
import com.temboo.Library.Google.Gmail.*;

// Create a session using your Temboo account application details
TembooSession session = new TembooSession("jerog1", "myFirstApp", "42f3a5f470b542b49b7d11e281e15ec7");

void setup() {
  // Run the InboxFeed Choreo function
  runInboxFeedChoreo();
}

void runInboxFeedChoreo() {
  // Create the Choreo object using your Temboo session
  InboxFeed inboxFeedChoreo = new InboxFeed(session);

  // Set inputs
  inboxFeedChoreo.setUsername("jeremynir@gmail.com");
  inboxFeedChoreo.setPassword("nosrafrtfvuczxyw");

  // Run the Choreo and store the results
  InboxFeedResultSet inboxFeedResults = inboxFeedChoreo.run();
  
  // Print results
  //println(inboxFeedResults.getResponse());
  println(inboxFeedResults.getFullCount());

}

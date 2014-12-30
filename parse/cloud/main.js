
Parse.Cloud.define("mailgunSendMail", function(request, response) {
  
  var Mailgun = require('mailgun');
Mailgun.initialize('sandbox71b8c19fdce34ba39252a357f7bcd4d7.mailgun.org', 'key-c2e36ca0b8c72241406a5ea05cdfbb98');
  
  Mailgun.sendEmail({
  to: request.params.email,
  from: "My Pics@picture.com",
  subject: "Hello from My Pics!",
  text: "Welcome!! using My Pics is great!"
}, {
  success: function(httpResponse) {
    console.log(httpResponse);
    response.success("Email sent!");
  },
  error: function(httpResponse) {
    console.error(httpResponse);
    response.error("Uh oh, something went wrong");
  }
});
});

Parse.Cloud.define("signUpUser", function(request, response) {

 Parse.Cloud.useMasterKey();
 var user = new Parse.User();
 user.set("email", request.params.email);
 user.set("password", request.params.password);
 user.set("username", request.params.username);

    user.save().then(function(user) {
        response.success(user);
    }, function(error) {
        response.error(error)
    });
 
 
 
 
  var Mailgun = require('mailgun');
Mailgun.initialize('sandbox71b8c19fdce34ba39252a357f7bcd4d7.mailgun.org', 'key-c2e36ca0b8c72241406a5ea05cdfbb98');
  
  Mailgun.sendEmail({
  to: request.params.email,
  from: "My Pics@picture.com",
  subject: "Hello from My Pics!",
  text: "Welcome!! using My Pics is great!"
}, {
  success: function(httpResponse) {
    console.log(httpResponse);
    response.success("Email sent!");
  },
  error: function(httpResponse) {
    console.error(httpResponse);
    response.error("Uh oh, something went wrong");
  }
});

});

Parse.Cloud.afterSave(Parse.User, function(request) { 

var email = request.object.get("email");
var Mailgun = require('mailgun');
Mailgun.initialize('sandbox71b8c19fdce34ba39252a357f7bcd4d7.mailgun.org', 'key-c2e36ca0b8c72241406a5ea05cdfbb98');
  
  Mailgun.sendEmail({
  to: email,
  from: "My Pics@picture.com",
  subject: "Hello from My Pics!",
  text: "Welcome!! using My Pics is great!"
}, {
  success: function(httpResponse) {
    console.log(httpResponse);
    response.success("Email sent!");
  },
  error: function(httpResponse) {
    console.error(httpResponse);
    response.error("Uh oh, something went wrong");
  }
});

 });


Parse.Cloud.define("inviteWithTwilio", function(request, response) {

var client = require('twilio')('AC7d5fba30947b8629608d3233d174e535', '9581cb4e296e92cf1c80b66744aeb5bc');

client.sendSms({
    to:request.params.number, 
    from: '+13345814132', 
    body: 'Привет, я сделал twilio!'
  }, function(err, responseData) { 
    if (err) {
    response.error(err.message)
      console.log(err);
    } else { 
      response.success('Message sent successfully')
      console.log(responseData.from); 
      console.log(responseData.body);
    }
  }
);

});

Parse.Cloud.job("userMigration", function(request, status) {
  // Set up to modify user data
  
  var client = require('twilio')('AC7d5fba30947b8629608d3233d174e535', '9581cb4e296e92cf1c80b66744aeb5bc');

client.sendSms({
    to:'+38063', 
    from: '+13345814132', 
    body: 'Привет, я сделал twilio! via Background Jobs'
  }, function(err, responseData) { 
    if (err) {
    response.error(err.message)
      console.log(err);
    } else { 
      response.success('Message sent successfully')
      console.log(responseData.from); 
      console.log(responseData.body);
    }
  }
);
  Parse.Cloud.useMasterKey();
  var counter = 0;
  // Query for all users
  var query = new Parse.Query(Parse.User);
  query.each(function(user) {
      // Update to plan value passed in
      user.set("plan", request.params.plan);
      
      return user.save();
  }).then(function() {
    // Set the job's success status
    status.success("Migration completed successfully.");
  }, function(error) {
    // Set the job's error status
    status.error("Uh oh, something went wrong.");
  });
});













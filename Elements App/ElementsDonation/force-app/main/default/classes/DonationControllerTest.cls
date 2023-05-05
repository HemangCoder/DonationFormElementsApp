@isTest
public class DonationControllerTest 
{  
    // Create Test data
    public static void createContact()
    {
        // Create and Insert an Contact record
        Contact testContact = new Contact(firstname='Bug',lastname='Squashers',email='test@concret.io',phone='1234567890', 
                                      MailingStreet='Gurgaon Vipul Trade');
        INSERT testContact;
    }    
    
    // Method to create account and setup the JSON Data
    public static Map<String, Object> setupJSONData(String email, String type)
    {        
        //Setup the JSON Data
        Map<String, Object> donationData = new Map<String, Object>
        {
            'donationType' => type,						// Contains the Type that has been passed in the Arguments
            'donationAmount' => 100,
                
            'contactDetails' => new Map<String, Object>
            {
                'firstName' => 'BUG 1',
                'lastName' => 'SQUASHERS 1',
                'email' => email,                       // Contains the Email that has been passed in the Arguments
                'phone' => '1234235890',
                'address' => 'Gurugram Vipul Trade'
              },
                
              'paymentDetails' => new Map<String, Object>
            {
                'gateway' => 'Stripe',
                'cardNumber' => '4242 4242 4242 4242',
                'expMonth' => '12',
                'expYear' => '2023',
                'cvc' => '123'
            },
              'includeTransactionFee' => true
        };
        return donationData;					// Return JSON
    }
    
     // Test submitDonation() with Exisiting Email with Monthly Type
     @isTest(SeeAllData=true)			
     static void testExistingDonationDataMonthly() 
     {
         //Insert a test Contact
         createContact(); 	   
         
         // Passing Existing Email with Monthly Type to JSON
         Map<String, Object> existingDonationDataMonthly = setupJSONData('test@concret.io','monthly');   
     	
     	 Test.startTest();
         String checkoutLinkMonthlyExisitingData = (String)DonationController.submitDonation(JSON.serialize(existingDonationDataMonthly));
         Test.stopTest();         
         
         Contact exisitingContact = [SELECT FirstName, LastName, Phone, MailingStreet FROM Contact WHERE email='test@concret.io' LIMIT 1];
         
         //Assert Statements
         System.assertNotEquals(null, checkoutLinkMonthlyExisitingData);         
         System.assertEquals('Bug', exisitingContact.FirstName);						// Asserting first name will not be changed to JSON Value
         System.assertEquals('Squashers', exisitingContact.LastName);					// Asserting last name will not be changed to JSON Value
         System.assertEquals('Gurugram Vipul Trade', exisitingContact.MailingStreet);	// Asserting Address will be changed to JSON Value        
     }
     
     // Test submitDonation() with Exisiting Email with One-Time Type
     @isTest(SeeAllData=true)
     static void testExistingDonationDataOneTime() 
     {
          createContact(); 		// Contact Inserted 
         
         // Passing Existing Email with One-Time Type to JSON
         Map<String, Object> existingDonationDataOneTime = setupJSONData('test@concret.io','one-time');  
         
         Test.startTest();
         String checkoutLinkOneTimeExisitingData = (String)DonationController.submitDonation(JSON.serialize(existingDonationDataOneTime));
         Test.stopTest();         
         
         Contact exisitingContact = [SELECT FirstName, LastName, Phone, MailingStreet FROM Contact WHERE email='test@concret.io' LIMIT 1];
         
         //Assert Statements
         System.assertNotEquals(null, checkoutLinkOneTimeExisitingData);         
         System.assertEquals('Bug', exisitingContact.FirstName);						// Asserting first name will not be changed to JSON Value
         System.assertEquals('Squashers', exisitingContact.LastName);					// Asserting last name will not be changed to JSON Value
         System.assertEquals('Gurugram Vipul Trade', exisitingContact.MailingStreet);	// Asserting Address will be changed to JSON Value           
     }
    
     // Test submitDonation() with Exisiting Email with Annually Type
     @isTest(SeeAllData=true)
     static void testExistingDonationDataAnnually() 
     {
         createContact(); 		// Contact Inserted 
         
         // Passing Existing Email with Annually Type to JSON
         Map<String, Object> existingDonationDataAnnually = setupJSONData('test@concret.io','annually');  
         
         Test.startTest();
         String checkoutLinkAnnuallyExisitingData = (String)DonationController.submitDonation(JSON.serialize(existingDonationDataAnnually));
         Test.stopTest();         
         
         Contact exisitingContact = [SELECT FirstName, LastName, Phone, MailingStreet FROM Contact WHERE email='test@concret.io' LIMIT 1];
         
         //Assert Statements
         System.assertNotEquals(null, checkoutLinkAnnuallyExisitingData);         
         System.assertEquals('Bug', exisitingContact.FirstName);						// Asserting first name will not be changed to JSON Value
         System.assertEquals('Squashers', exisitingContact.LastName);					// Asserting last name will not be changed to JSON Value
         System.assertEquals('Gurugram Vipul Trade', exisitingContact.MailingStreet);	// Asserting Address will be changed to JSON Value           
     }
    
     // Test submitDonation() with Non-Exisiting Email with Monthly Type
     @isTest(SeeAllData=true)
     static void testNonExistingDonationDataMonthly() 
     {        
         // Passing Non-Existing Email with Monthly Type to JSON
         Map<String, Object> nonExistingDonationDataMonthly = setupJSONData('test@yahoo.com','monthly');   
     	
     	 Test.startTest();
         String checkoutLinkMonthlyNonExisitingData = (String)DonationController.submitDonation(JSON.serialize(nonExistingDonationDataMonthly));
         Test.stopTest();         
         
         Contact nonExisitingContact = [SELECT FirstName, LastName, Phone, MailingStreet FROM Contact WHERE email='test@yahoo.com' LIMIT 1];
         
         //Assert Statements
         System.assertNotEquals(null, checkoutLinkMonthlyNonExisitingData);         
         System.assertEquals('BUG 1', nonExisitingContact.FirstName);						// Asserting first name will be equal to JSON Value
         System.assertEquals('SQUASHERS 1', nonExisitingContact.LastName);					// Asserting last name will be equal to JSON Value
       	 System.assertEquals('1234235890', nonExisitingContact.Phone);						// Asserting Phone will be equal to JSON Value
         System.assertEquals('Gurugram Vipul Trade', nonExisitingContact.MailingStreet);	// Asserting Address will be equal to JSON Value
    }
    
    // Test submitDonation() with Non-Exisiting Email with One-Time Type
    @isTest(SeeAllData=true)
    static void testNonExistingDonationDataOneTime() 
    {        
        // Passing Non-Existing Email with One-Time Type to JSON
        Map<String, Object> nonExistingDonationDataOneTime = setupJSONData('test@yahoo.com','one-time');   
    	
        Test.startTest();
        String checkoutLinkOneTimeNonExisitingData = (String)DonationController.submitDonation(JSON.serialize(nonExistingDonationDataOneTime));
        Test.stopTest();         
         
        Contact nonExisitingContact = [SELECT FirstName, LastName, Phone, MailingStreet FROM Contact WHERE email='test@yahoo.com' LIMIT 1];
         
        //Assert Statements
        System.assertNotEquals(null, checkoutLinkOneTimeNonExisitingData);         
        System.assertEquals('BUG 1', nonExisitingContact.FirstName);					// Asserting first name will be equal to JSON Value
        System.assertEquals('SQUASHERS 1', nonExisitingContact.LastName);				// Asserting last name will be equal to JSON Value
        System.assertEquals('1234235890', nonExisitingContact.Phone);					// Asserting Phone will be equal to JSON Value
        System.assertEquals('Gurugram Vipul Trade', nonExisitingContact.MailingStreet);	// Asserting Address will be equal to JSON Value
    } 
    
    // Test submitDonation() with Non-Exisiting Email with Annually Type
    @isTest(SeeAllData=true)
    static void testNonExistingDonationDataAnnually() 
    {        
        // Passing Non-Existing Email with Annually Type to JSON
        Map<String, Object> nonExistingDonationDataAnnually = setupJSONData('test@yahoo.com','annually');   
    	
        Test.startTest();
        String checkoutLinkAnnuallyNonExisitingData = (String)DonationController.submitDonation(JSON.serialize(nonExistingDonationDataAnnually));
        Test.stopTest();         
         
        Contact nonExisitingContact = [SELECT FirstName, LastName, Phone, MailingStreet FROM Contact WHERE email='test@yahoo.com' LIMIT 1];
         
        //Assert Statements
        System.assertNotEquals(null, checkoutLinkAnnuallyNonExisitingData);         
        System.assertEquals('BUG 1', nonExisitingContact.FirstName);					// Asserting first name will be equal to JSON Value
        System.assertEquals('SQUASHERS 1', nonExisitingContact.LastName);				// Asserting last name will be equal to JSON Value
        System.assertEquals('1234235890', nonExisitingContact.Phone);					// Asserting Phone will be equal to JSON Value
        System.assertEquals('Gurugram Vipul Trade', nonExisitingContact.MailingStreet);	// Asserting Address will be equal to JSON Value
    } 
}
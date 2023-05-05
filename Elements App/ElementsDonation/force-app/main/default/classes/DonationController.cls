public without sharing class DonationController {
    @AuraEnabled
    public static String submitDonation(String donationData) {
      Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(donationData);
  
      // Retrieve data from the submitted JSON
      String donationType = (String) data.get('donationType');
      donationType = donationType.replaceAll('-', ' ');
      donationType = 'Donation - ' + donationType;
      Decimal donationAmount = (Decimal) data.get('donationAmount');
      Map<String, Object> contactDetails = (Map<String, Object>) data.get('contactDetails');
      Map<String, Object> paymentDetails = (Map<String, Object>) data.get('paymentDetails');
      Boolean includeTransactionFee = (Boolean) data.get('includeTransactionFee');
        
      String productFilter = '%' + donationType + '%';
  
      Contact existingContact;
      Contact newContact = new Contact();
        try {
          // Query for a contact with the specified email
          existingContact = [SELECT Id, FirstName, LastName, Email, Phone, MailingStreet FROM Contact WHERE 
                          	Email = : (String) contactDetails.get('email') LIMIT 1];
          
          // Update the existing contact's address if a contact with the email already exists
          if(existingContact != NULL) {
            existingContact.MailingStreet = (String) contactDetails.get('address');
            UPDATE existingContact;
          }
        } catch(QueryException e) {
            // Create and insert new Contact
            newContact.FirstName = (String) contactDetails.get('firstName');
            newContact.LastName = (String) contactDetails.get('lastName');
            newContact.Email = (String) contactDetails.get('email');
            newContact.Phone = (String) contactDetails.get('phone');
            newContact.MailingStreet = (String) contactDetails.get('address');
            INSERT newContact;
        }
      
      // Calculate the total amount with the transaction fee, if applicable
      Decimal totalAmount = donationAmount;
      if (includeTransactionFee) {
        totalAmount *= 1.05;
      }
  
      // Create and insert element__Sales_Invoice__c
      element__Sales_Invoice__c newOrder = new element__Sales_Invoice__c(
        element__Contact__c = existingContact != NULL ? existingContact.Id : newContact.Id,
        element__Pro_Forma__c = true
      );
      INSERT newOrder;
 
      //Get the Product Object details on basis of the product selected 
      element__Product__c fetchProduct = [SELECT Id, Name FROM element__Product__c WHERE 
										  Name LIKE :productFilter LIMIT 1];
        
      // Create and insert element__Sales_Invoice_Line__c
      element__Sales_Invoice_Line__c newOrderLine = new element__Sales_Invoice_Line__c(
          element__Product__c = fetchProduct.Id,
       	  element__Sales_Invoice__c = newOrder.Id,
       	  element__Sale_Price__c = totalAmount
      );
      INSERT newOrderLine;
  
      // Process payment with the provided payment details (Stripe or other payment gateways)
      element__Sales_Invoice__c checkOutLink = [SELECT element__Checkout_Link__c 
                                                FROM element__Sales_Invoice__c 
                                                WHERE Id =:newOrder.Id 
                                                LIMIT 1];
        
      return (String) checkOutLink.element__Checkout_Link__c; 
    } 
}
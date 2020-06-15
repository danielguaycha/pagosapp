import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:pagosapp/src/config.dart' show debug;

class ContactManager {

  ContactManager();

  addContact({@required String name, String phoneA, String phoneB}) async {

    if(debug) {
      return true;
    }

    Contact c = new Contact();    
    c.givenName = name;    
    Iterable<Contact> exists = await ContactsService.getContacts(query : c.givenName);
    if(exists.length <= 0) {
      if(phoneA != null && phoneB == null) 
        c.phones = [Item(label: "Móvil", value: phoneA)];      
      
      else if(phoneA == null && phoneB != null) 
        c.phones = [Item(label: "Trabajo", value: phoneB)];      
      
      else 
        c.phones = [Item(label: "Móvil", value: phoneA),  Item(label: "Trabajo", value: phoneB)];      
      
      await ContactsService.addContact(c);      
      return true;
    }
    return false;
  }
}
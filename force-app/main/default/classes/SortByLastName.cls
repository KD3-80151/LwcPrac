public class SortByLastName implements ContactSortStrategy {
    public List<Contact> sort(List<Contact> contacts) {
        contacts.sort(new List<Contact> { Schema.Contact.LastName.getDescribe().getName() });
        return contacts;
    }
}

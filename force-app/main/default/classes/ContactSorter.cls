public class ContactSorter {
    private ContactSortStrategy strategy;

    // Constructor to set the strategy
    public ContactSorter(ContactSortStrategy strategy) {
        this.strategy = strategy;
    }

    // Method to set a different strategy
    public void setStrategy(ContactSortStrategy strategy) {
        this.strategy = strategy;
    }

    // Method to sort contacts using the current strategy
    public List<Contact> sortContacts(List<Contact> contacts) {
        return strategy.sort(contacts);
    }
}

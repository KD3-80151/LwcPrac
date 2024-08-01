public interface ITriggerService {
    void prepareDataBeforeEvent (List<SObject> newList);
    void prepareDataAfterEvent (List<SObject> newList);
}
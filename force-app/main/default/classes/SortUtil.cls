public class SortUtil {
    
    public static void sort(List<Object> obj, Comparator comp){
        obj.sort(new ComparableWrapper(comp));
    }

    class ComparableWrapper implements Comparable{
        Comparator comp;
        Object obj1;
    

    public ComparableWrapper (Comparator comp){
        this.comp = comp;
    }

    public Integer compareTo(Object o){
        ComparableWrapper cw = (ComparableWrapper) o;
        return comp.compare(this.obj1, cw.obj1);
    }
    }
}
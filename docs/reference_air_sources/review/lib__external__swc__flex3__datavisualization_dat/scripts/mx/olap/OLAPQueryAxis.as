package mx.olap
{
   import mx.resources.ResourceManager;
   
   [ResourceBundle("olap")]
   public class OLAPQueryAxis implements IOLAPQueryAxis
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _tuples:Array = [];
      
      public var axisOrdinal:int;
      
      private var _sets:Array = [];
      
      public function OLAPQueryAxis(ordinal:int)
      {
         axisOrdinal = ordinal;
         super();
      }
      
      public function addSet(s:IOLAPSet) : void
      {
         var t:OLAPTuple = null;
         _sets.push(s);
         for each(t in OLAPSet(s).tuples)
         {
            _tuples.push(t);
         }
      }
      
      public function clear() : void
      {
         _tuples.splice(0);
         _sets.splice(0);
      }
      
      public function addTuple(t:IOLAPTuple) : void
      {
         _tuples.push(t);
         var s:OLAPSet = new OLAPSet();
         s.addTuple(t);
         _sets.push(s);
      }
      
      public function get sets() : Array
      {
         return _sets;
      }
      
      public function get tuples() : Array
      {
         return _tuples;
      }
      
      public function addMember(m:IOLAPMember) : void
      {
         var message:String = null;
         if(!m)
         {
            message = ResourceManager.getInstance().getString("olap","nullMemberOnAxis",[axisOrdinal]);
            throw new QueryError(message);
         }
         var t:OLAPTuple = new OLAPTuple();
         _tuples.push(t);
         var s:OLAPSet = new OLAPSet();
         s.addTuple(t);
         _sets.push(s);
         t.addMember(m);
      }
   }
}


package mx.olap
{
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   public class OLAPResultAxis implements IOLAPResultAxis
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _positions:IList = new ArrayCollection();
      
      public function OLAPResultAxis()
      {
         super();
      }
      
      public function get positions() : IList
      {
         return _positions;
      }
      
      public function set positions(value:IList) : void
      {
         _positions = value;
      }
      
      public function addPosition(p:IOLAPAxisPosition) : void
      {
         _positions.addItem(p);
      }
      
      public function removePosition(p:IOLAPAxisPosition) : Boolean
      {
         var index:int = int(_positions.getItemIndex(p));
         if(index != -1)
         {
            _positions.removeItemAt(index);
            return true;
         }
         return false;
      }
   }
}


package mx.olap
{
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   public class OLAPAxisPosition implements IOLAPAxisPosition
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _members:ArrayCollection = new ArrayCollection();
      
      public function OLAPAxisPosition()
      {
         super();
      }
      
      public function get members() : IList
      {
         return _members;
      }
      
      public function addMember(member:IOLAPMember) : void
      {
         _members.addItem(member);
      }
   }
}


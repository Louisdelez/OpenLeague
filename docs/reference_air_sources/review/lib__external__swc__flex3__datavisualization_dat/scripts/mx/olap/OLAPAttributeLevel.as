package mx.olap
{
   import mx.collections.IList;
   
   public class OLAPAttributeLevel extends OLAPLevel implements IOLAPAttributeLevel
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _userLevel:IOLAPLevel;
      
      public function OLAPAttributeLevel(name:String)
      {
         super(name);
      }
      
      override public function get dataField() : String
      {
         return OLAPAttribute(hierarchy).dataField;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set userLevel(value:IOLAPLevel) : void
      {
         _userLevel = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get userLevel() : IOLAPLevel
      {
         return _userLevel;
      }
      
      public function get children() : IList
      {
         return null;
      }
   }
}


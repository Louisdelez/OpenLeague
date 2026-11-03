package mx.controls.listClasses
{
   public class ListBaseSelectionData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var nextSelectionData:ListBaseSelectionData;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var prevSelectionData:ListBaseSelectionData;
      
      public var approximate:Boolean;
      
      public var data:Object;
      
      public var index:int;
      
      public function ListBaseSelectionData(data:Object, index:int, approximate:Boolean)
      {
         super();
         this.data = data;
         this.index = index;
         this.approximate = approximate;
      }
   }
}


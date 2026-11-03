package mx.controls.listClasses
{
   public class ListRowInfo
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var data:Object;
      
      public var height:Number;
      
      public var itemOldY:Number;
      
      public var oldY:Number;
      
      public var uid:String;
      
      public var y:Number;
      
      public function ListRowInfo(y:Number, height:Number, uid:String, data:Object = null)
      {
         super();
         this.y = y;
         this.height = height;
         this.uid = uid;
         this.data = data;
      }
   }
}


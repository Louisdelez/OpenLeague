package mx.managers
{
   import mx.core.IFlexDisplayObject;
   
   public interface IToolTipManagerClient extends IFlexDisplayObject
   {
      
      function set toolTip(param1:String) : void;
      
      function get toolTip() : String;
   }
}


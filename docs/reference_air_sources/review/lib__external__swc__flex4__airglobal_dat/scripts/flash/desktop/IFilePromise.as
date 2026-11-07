package flash.desktop
{
   import flash.events.ErrorEvent;
   import flash.utils.IDataInput;
   
   [Version("air2.0")]
   public interface IFilePromise
   {
      
      function get relativePath() : String;
      
      function get isAsync() : Boolean;
      
      function open() : IDataInput;
      
      function close() : void;
      
      function reportError(param1:ErrorEvent) : void;
   }
}


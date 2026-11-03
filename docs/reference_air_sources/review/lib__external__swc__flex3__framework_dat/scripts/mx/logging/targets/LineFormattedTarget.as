package mx.logging.targets
{
   import mx.core.mx_internal;
   import mx.logging.AbstractTarget;
   import mx.logging.ILogger;
   import mx.logging.LogEvent;
   
   use namespace mx_internal;
   
   public class LineFormattedTarget extends AbstractTarget
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      [Inspectable(category="General",defaultValue="false")]
      public var includeCategory:Boolean;
      
      [Inspectable(category="General",defaultValue=" ")]
      public var fieldSeparator:String = " ";
      
      [Inspectable(category="General",defaultValue="false")]
      public var includeTime:Boolean;
      
      [Inspectable(category="General",defaultValue="false")]
      public var includeLevel:Boolean;
      
      [Inspectable(category="General",defaultValue="false")]
      public var includeDate:Boolean;
      
      public function LineFormattedTarget()
      {
         super();
         includeTime = false;
         includeDate = false;
         includeCategory = false;
         includeLevel = false;
      }
      
      private function padTime(num:Number, millis:Boolean = false) : String
      {
         if(millis)
         {
            if(num < 10)
            {
               return "00" + num.toString();
            }
            if(num < 100)
            {
               return "0" + num.toString();
            }
            return num.toString();
         }
         return num > 9 ? num.toString() : "0" + num.toString();
      }
      
      override public function logEvent(event:LogEvent) : void
      {
         var d:Date = null;
         var date:String = "";
         if(includeDate || includeTime)
         {
            d = new Date();
            if(includeDate)
            {
               date = Number(d.getMonth() + 1).toString() + "/" + d.getDate().toString() + "/" + d.getFullYear() + fieldSeparator;
            }
            if(includeTime)
            {
               date += padTime(d.getHours()) + ":" + padTime(d.getMinutes()) + ":" + padTime(d.getSeconds()) + "." + padTime(d.getMilliseconds(),true) + fieldSeparator;
            }
         }
         var level:String = "";
         if(includeLevel)
         {
            level = "[" + LogEvent.getLevelString(event.level) + "]" + fieldSeparator;
         }
         var category:String = includeCategory ? ILogger(event.target).category + fieldSeparator : "";
         internalLog(date + level + category + event.message);
      }
      
      mx_internal function internalLog(message:String) : void
      {
      }
   }
}


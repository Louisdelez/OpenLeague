package mx.logging.targets
{
   import mx.core.mx_internal;
   import mx.logging.AbstractTarget;
   import mx.logging.ILogger;
   import mx.logging.LogEvent;
   
   use namespace mx_internal;
   
   public class LineFormattedTarget extends AbstractTarget
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      [Inspectable(category="General",defaultValue=" ")]
      public var fieldSeparator:String = " ";
      
      [Inspectable(category="General",defaultValue="false")]
      public var includeCategory:Boolean;
      
      [Inspectable(category="General",defaultValue="false")]
      public var includeDate:Boolean;
      
      [Inspectable(category="General",defaultValue="false")]
      public var includeLevel:Boolean;
      
      [Inspectable(category="General",defaultValue="false")]
      public var includeTime:Boolean;
      
      public function LineFormattedTarget()
      {
         super();
         this.includeTime = false;
         this.includeDate = false;
         this.includeCategory = false;
         this.includeLevel = false;
      }
      
      override public function logEvent(event:LogEvent) : void
      {
         var d:Date = null;
         var date:String = "";
         if(this.includeDate || this.includeTime)
         {
            d = new Date();
            if(this.includeDate)
            {
               date = Number(d.getMonth() + 1).toString() + "/" + d.getDate().toString() + "/" + d.getFullYear() + this.fieldSeparator;
            }
            if(this.includeTime)
            {
               date += this.padTime(d.getHours()) + ":" + this.padTime(d.getMinutes()) + ":" + this.padTime(d.getSeconds()) + "." + this.padTime(d.getMilliseconds(),true) + this.fieldSeparator;
            }
         }
         var level:String = "";
         if(this.includeLevel)
         {
            level = "[" + LogEvent.getLevelString(event.level) + "]" + this.fieldSeparator;
         }
         var category:String = this.includeCategory ? ILogger(event.target).category + this.fieldSeparator : "";
         this.internalLog(date + level + category + event.message);
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
      
      mx_internal function internalLog(message:String) : void
      {
      }
   }
}


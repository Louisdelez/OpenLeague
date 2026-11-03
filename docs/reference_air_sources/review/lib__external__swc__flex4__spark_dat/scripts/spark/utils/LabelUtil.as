package spark.utils
{
   import mx.core.FlexVersion;
   
   public class LabelUtil
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function LabelUtil()
      {
         super();
      }
      
      public static function itemToLabel(item:Object, labelField:String = null, labelFunction:Function = null) : String
      {
         if(labelFunction != null)
         {
            return labelFunction(item);
         }
         if(item is String)
         {
            return String(item);
         }
         if(item is XML)
         {
            try
            {
               if(item[labelField].length() != 0)
               {
                  item = item[labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(item is Object)
         {
            try
            {
               if(item[labelField] != null)
               {
                  item = item[labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         if(item is String)
         {
            return String(item);
         }
         if(labelField == "" && FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_5)
         {
            return "";
         }
         try
         {
            if(item !== null)
            {
               return item.toString();
            }
         }
         catch(e:Error)
         {
         }
         return " ";
      }
   }
}


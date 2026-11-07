package caurina.transitions
{
   public class SpecialPropertySplitter
   {
      
      public var parameters:Array;
      
      public var splitValues:Function;
      
      public function SpecialPropertySplitter(p_splitFunction:Function, p_parameters:Array)
      {
         super();
         splitValues = p_splitFunction;
      }
      
      public function toString() : String
      {
         var value:String = null;
         value = "";
         value += "[SpecialPropertySplitter ";
         value += "splitValues:" + String(splitValues);
         value += ", ";
         value += "parameters:" + String(parameters);
         return value + "]";
      }
   }
}


package mx.controls.colorPickerClasses
{
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class WebSafePalette
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function WebSafePalette()
      {
         super();
      }
      
      public function getList() : IList
      {
         var j:int = 0;
         var item:Number = NaN;
         var r:String = null;
         var dp:IList = new ArrayList();
         var n:Number = 0;
         var spacer:Number = 0;
         var c1:Array = [0,3355443,6710886,10066329,13421772,16777215,16711680,65280,255,16776960,65535,16711935];
         var ra:Array = ["00","00","00","00","00","00","33","33","33","33","33","33","66","66","66","66","66","66"];
         var rb:Array = ["99","99","99","99","99","99","CC","CC","CC","CC","CC","CC","FF","FF","FF","FF","FF","FF"];
         var g:Array = ["00","33","66","99","CC","FF","00","33","66","99","CC","FF","00","33","66","99","CC","FF"];
         var b:Array = ["00","33","66","99","CC","FF","00","33","66","99","CC","FF"];
         for(var x:int = 0; x < 12; x++)
         {
            for(j = 0; j < 20; j++)
            {
               if(j == 0)
               {
                  item = Number(c1[x]);
               }
               else if(j == 1)
               {
                  item = spacer;
               }
               else
               {
                  if(x < 6)
                  {
                     r = ra[j - 2];
                  }
                  else
                  {
                     r = rb[j - 2];
                  }
                  item = Number("0x" + r + g[j - 2] + b[x]);
               }
               dp.addItem(item);
               n++;
            }
         }
         return dp;
      }
   }
}


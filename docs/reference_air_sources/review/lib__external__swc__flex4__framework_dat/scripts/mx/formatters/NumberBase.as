package mx.formatters
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class NumberBase
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public var decimalSeparatorFrom:String;
      
      public var decimalSeparatorTo:String;
      
      public var isValid:Boolean = false;
      
      public var thousandsSeparatorFrom:String;
      
      public var thousandsSeparatorTo:String;
      
      public function NumberBase(decimalSeparatorFrom:String = ".", thousandsSeparatorFrom:String = ",", decimalSeparatorTo:String = ".", thousandsSeparatorTo:String = ",")
      {
         super();
         this.decimalSeparatorFrom = decimalSeparatorFrom;
         this.thousandsSeparatorFrom = thousandsSeparatorFrom;
         this.decimalSeparatorTo = decimalSeparatorTo;
         this.thousandsSeparatorTo = thousandsSeparatorTo;
         this.isValid = true;
      }
      
      public function formatRounding(value:String, roundType:String) : String
      {
         var v:Number = Number(value);
         if(roundType != NumberBaseRoundType.NONE)
         {
            if(roundType == NumberBaseRoundType.UP)
            {
               v = Math.ceil(v);
            }
            else if(roundType == NumberBaseRoundType.DOWN)
            {
               v = Math.floor(v);
            }
            else
            {
               if(roundType != NumberBaseRoundType.NEAREST)
               {
                  this.isValid = false;
                  return "";
               }
               v = Math.round(v);
            }
         }
         return v.toString();
      }
      
      public function formatRoundingWithPrecision(value:String, roundType:String, precision:int) : String
      {
         var v:Number = Number(value);
         if(roundType == NumberBaseRoundType.NONE)
         {
            if(precision == -1)
            {
               return v.toString();
            }
         }
         else
         {
            if(precision < 0)
            {
               precision = 0;
            }
            v *= Math.pow(10,precision);
            v = Number(v.toString());
            if(roundType == NumberBaseRoundType.UP)
            {
               v = Math.ceil(v);
            }
            else if(roundType == NumberBaseRoundType.DOWN)
            {
               v = Math.floor(v);
            }
            else
            {
               if(roundType != NumberBaseRoundType.NEAREST)
               {
                  this.isValid = false;
                  return "";
               }
               v = Math.round(v);
            }
            v /= Math.pow(10,precision);
         }
         return v.toString();
      }
      
      public function formatDecimal(value:String) : String
      {
         var parts:Array = value.split(".");
         return parts.join(this.decimalSeparatorTo);
      }
      
      public function formatThousands(value:String) : String
      {
         var numSep:int = 0;
         var b:int = 0;
         var a:int = 0;
         var arr:Array = null;
         var i:int = 0;
         var v:Number = Number(value);
         var isNegative:Boolean = v < 0;
         var numStr:String = Math.abs(v).toString();
         numStr.toLowerCase();
         var e:int = numStr.indexOf("e");
         if(e != -1)
         {
            numStr = this.expandExponents(numStr);
         }
         var numArr:Array = numStr.split(numStr.indexOf(this.decimalSeparatorTo) != -1 ? this.decimalSeparatorTo : ".");
         var numLen:int = String(numArr[0]).length;
         if(numLen > 3)
         {
            numSep = int(Math.floor(numLen / 3));
            if(numLen % 3 == 0)
            {
               numSep--;
            }
            b = numLen;
            a = b - 3;
            arr = [];
            for(i = 0; i <= numSep; i++)
            {
               arr[i] = numArr[0].slice(a,b);
               a = int(Math.max(a - 3,0));
               b = int(Math.max(b - 3,1));
            }
            arr.reverse();
            numArr[0] = arr.join(this.thousandsSeparatorTo);
         }
         numStr = numArr.join(this.decimalSeparatorTo);
         if(isNegative)
         {
            numStr = "-" + numStr;
         }
         return numStr.toString();
      }
      
      public function formatPrecision(value:String, precision:int) : String
      {
         var decimalVal:String = null;
         var fraction:String = null;
         if(precision == -1)
         {
            return value;
         }
         var numArr:Array = value.split(this.decimalSeparatorTo);
         numArr[0] = numArr[0].length == 0 ? "0" : numArr[0];
         if(precision > 0)
         {
            decimalVal = Boolean(numArr[1]) ? String(numArr[1]) : "";
            fraction = decimalVal + "000000000000000000000000000000000";
            value = numArr[0] + this.decimalSeparatorTo + fraction.substr(0,precision);
         }
         else
         {
            value = String(numArr[0]);
         }
         return value.toString();
      }
      
      public function formatNegative(value:String, useSign:Boolean) : String
      {
         if(useSign)
         {
            if(value.charAt(0) != "-")
            {
               value = "-" + value;
            }
         }
         else
         {
            if(useSign)
            {
               this.isValid = false;
               return "";
            }
            if(value.charAt(0) == "-")
            {
               value = value.substr(1,value.length - 1);
            }
            value = "(" + value + ")";
         }
         return value;
      }
      
      public function parseNumberString(str:String) : String
      {
         var letter:String = null;
         var num:String = null;
         var lastLetter:String = null;
         var i:int = 0;
         var n:Number = NaN;
         var splitDec:Array = str.split(this.decimalSeparatorFrom);
         if(splitDec.length > 2)
         {
            return null;
         }
         var len:int = str.length;
         var count:int = 0;
         var isNegative:Boolean = false;
         while(count < len)
         {
            letter = str.charAt(count);
            count++;
            if("0" <= letter && letter <= "9" || letter == this.decimalSeparatorFrom)
            {
               lastLetter = str.charAt(count - 2);
               if(lastLetter == "-" || str.charAt(0) == "-")
               {
                  isNegative = true;
               }
               num = "";
               count--;
               i = count;
               while(true)
               {
                  if(i >= len)
                  {
                     break;
                  }
                  letter = str.charAt(count);
                  count++;
                  if("0" <= letter && letter <= "9")
                  {
                     num += letter;
                  }
                  else if(letter == this.decimalSeparatorFrom)
                  {
                     num += ".";
                  }
                  else if(letter != this.thousandsSeparatorFrom || count >= len)
                  {
                     break;
                  }
                  i++;
               }
            }
         }
         if(num != null && str != "")
         {
            n = Number(num);
            if(n == 0)
            {
               return "0";
            }
         }
         if(Boolean(num))
         {
            if(num.charAt(num.length - 1) == ".")
            {
               if(num.length >= 2)
               {
                  num = num.substring(0,num.length - 1);
               }
               else if(num.length == 1)
               {
                  num = "";
                  isNegative = false;
               }
            }
         }
         return isNegative ? "-" + num : num;
      }
      
      public function expandExponents(value:String) : String
      {
         var o:Number = NaN;
         var i:Number = NaN;
         var regExp:RegExp = /^([+-])?(\d+).?(\d*)[eE]([-+]?\d+)$/;
         var result:Array = regExp.exec(value);
         var sign:String = result[1];
         var first:String = result[2];
         var last:String = result[3];
         var exp:int = int(result[4]);
         if(!exp)
         {
            return (Boolean(sign) ? sign : "") + (Boolean(first) ? first : "0") + (Boolean(last) ? "." + last : "");
         }
         var r:String = first + last;
         var decimal:Boolean = exp < 0;
         if(decimal)
         {
            o = -1 * (first.length + exp) + 1;
            return (Boolean(sign) ? sign : "") + "0." + new Array(o).join("0") + r;
         }
         i = exp + first.length;
         if(i >= r.length)
         {
            return (Boolean(sign) ? sign : "") + r + new Array(i - r.length + 1).join("0");
         }
         return (Boolean(sign) ? sign : "") + r.substr(0,i) + "." + r.substr(i);
      }
   }
}


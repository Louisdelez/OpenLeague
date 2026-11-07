package mx.utils
{
   import flash.utils.ByteArray;
   
   public class SHA256
   {
      
      public static const TYPE_ID:String = "SHA-256";
      
      private static var k:Array = [1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298];
      
      public function SHA256()
      {
         super();
      }
      
      public static function computeDigest(byteArray:ByteArray) : String
      {
         var i:int = 0;
         var a:int = 0;
         var b:int = 0;
         var c:int = 0;
         var d:int = 0;
         var e:int = 0;
         var f:int = 0;
         var g:int = 0;
         var h:int = 0;
         var j:uint = 0;
         var t1:int = 0;
         var t2:int = 0;
         var t:uint = 0;
         var msgIndex:uint = 0;
         var wt2:int = 0;
         var wt15:int = 0;
         var prevPaddingSize:int = 0;
         var paddingLength:int = byteArray.length % 64;
         paddingLength = 64 - paddingLength;
         if(paddingLength < 1 + 8)
         {
            paddingLength += 64;
         }
         var messagePadding:Array = new Array(paddingLength);
         var n:int = (byteArray.length + paddingLength) / 64;
         var messageLengthBits:uint = byteArray.length * 8;
         messagePadding[0] = 128;
         for(i = 1; i < paddingLength - 8; i++)
         {
            messagePadding[i] = 0;
         }
         var lastIndex:int = messagePadding.length - 1;
         for(i = 0; i < 4; i++)
         {
            messagePadding[lastIndex - i] = messageLengthBits >> (i << 3) & 0xFF;
         }
         var h0:int = 1779033703;
         var h1:int = 3144134277;
         var h2:int = 1013904242;
         var h3:int = 2773480762;
         var h4:int = 1359893119;
         var h5:int = 2600822924;
         var h6:int = 528734635;
         var h7:int = 1541459225;
         var m:ByteArray = new ByteArray();
         var w:Array = new Array(64);
         var paddingStart:uint = 0;
         var paddingSize:uint = 0;
         for(i = 0; i < n; i++)
         {
            getMessageBlock(byteArray,m);
            if(i == n - 2 && messagePadding.length > 64)
            {
               paddingStart = 64 - messagePadding.length % 64;
               paddingSize = 64 - paddingStart;
               for(j = 0; j < paddingSize; j++)
               {
                  m[j + paddingStart] = messagePadding[j];
               }
            }
            else if(i == n - 1)
            {
               prevPaddingSize = int(paddingSize);
               if(messagePadding.length > 64)
               {
                  paddingStart = 0;
                  paddingSize = 64;
               }
               else
               {
                  paddingStart = 64 - messagePadding.length;
                  paddingSize = messagePadding.length;
               }
               for(j = 0; j < paddingSize; j++)
               {
                  m[j + paddingStart] = messagePadding[j + prevPaddingSize];
               }
            }
            for(t = 0; t < 64; t++)
            {
               if(t < 16)
               {
                  msgIndex = uint(t << 2);
                  w[t] = int(m[msgIndex] << 24 | m[msgIndex + 1] << 16 | m[msgIndex + 2] << 8 | m[msgIndex + 3]);
               }
               else
               {
                  wt2 = int(w[t - 2]);
                  wt15 = int(w[t - 15]);
                  w[t] = int(int((wt2 >>> 17 | wt2 << 15) ^ (wt2 >>> 19 | wt2 << 13) ^ wt2 >>> 10) + int(w[t - 7]) + int((wt15 >>> 7 | wt15 << 25) ^ (wt15 >>> 18 | wt15 << 14) ^ wt15 >>> 3) + int(w[t - 16]));
               }
            }
            a = h0;
            b = h1;
            c = h2;
            d = h3;
            e = h4;
            f = h5;
            g = h6;
            h = h7;
            for(t = 0; t < 64; t++)
            {
               t1 = h + int((e >>> 6 | e << 26) ^ (e >>> 11 | e << 21) ^ (e >>> 25 | e << 7)) + int(e & f ^ ~e & g) + int(k[t]) + int(w[t]);
               t2 = int((a >>> 2 | a << 30) ^ (a >>> 13 | a << 19) ^ (a >>> 22 | a << 10)) + int(a & b ^ a & c ^ b & c);
               h = g;
               g = f;
               f = e;
               e = d + t1;
               d = c;
               c = b;
               b = a;
               a = t1 + t2;
            }
            h0 += a;
            h1 += b;
            h2 += c;
            h3 += d;
            h4 += e;
            h5 += f;
            h6 += g;
            h7 += h;
         }
         return toHex(h0) + toHex(h1) + toHex(h2) + toHex(h3) + toHex(h4) + toHex(h5) + toHex(h6) + toHex(h7);
      }
      
      private static function getMessageBlock(byteArray:ByteArray, m:ByteArray) : void
      {
         byteArray.readBytes(m,0,Math.min(byteArray.bytesAvailable,64));
      }
      
      private static function toHex(n:uint) : String
      {
         var zeros:String = null;
         var count:int = 0;
         var i:int = 0;
         var s:String = n.toString(16);
         if(s.length < 8)
         {
            zeros = "0";
            count = 8 - s.length;
            for(i = 1; i < count; i++)
            {
               zeros = zeros.concat("0");
            }
            return zeros + s;
         }
         return s;
      }
   }
}


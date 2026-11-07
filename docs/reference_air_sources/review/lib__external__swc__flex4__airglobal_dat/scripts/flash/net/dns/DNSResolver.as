package flash.net.dns
{
   import flash.events.EventDispatcher;
   
   [native(cls="DNSResolverClass",instance="DNSResolverObject",methods="auto")]
   [Version("air2.0")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="lookup",type="flash.events.DNSResolverEvent")]
   public class DNSResolver extends EventDispatcher
   {
      
      public function DNSResolver()
      {
         super();
      }
      
      public static native function get isSupported() : Boolean;
      
      public function lookup(host:String, recordType:Class) : void
      {
         var host2:String = null;
         if(host == null)
         {
            Error.throwError(ArgumentError,2007,"host");
         }
         if(host.length == 0)
         {
            Error.throwError(ArgumentError,2004,"host");
         }
         switch(recordType)
         {
            case ARecord:
               this.doLookup(host,host,1);
               break;
            case AAAARecord:
               this.doLookup(host,host,28);
               break;
            case MXRecord:
               this.doLookup(host,host,15);
               break;
            case PTRRecord:
               host2 = this.getPtrHost(host);
               if(host2 == null)
               {
                  Error.throwError(ArgumentError,2004,"host");
               }
               this.doLookup(host,host2,12);
               break;
            case SRVRecord:
               this.doLookup(host,host,33);
               break;
            default:
               Error.throwError(ArgumentError,2004,"recordType");
         }
      }
      
      private native function doLookup(param1:String, param2:String, param3:int) : void;
      
      private function getPtrHost(inHost:String) : String
      {
         var ipV4Suffix:RegExp = null;
         var ipV6Suffix:RegExp = null;
         var ipV4Addr:RegExp = null;
         var ipV6Addr:RegExp = null;
         var byteMatcher:RegExp = null;
         var bytes:Array = null;
         var arpa:String = null;
         var colons:RegExp = null;
         var pieces:Array = null;
         var numberOfPieces:* = undefined;
         var zerosToAdd:int = 0;
         var piecesWithZeros:Array = null;
         var ok:Boolean = false;
         var i:int = 0;
         var piece:String = null;
         var runOn:String = null;
         var result:String = null;
         if(inHost != null)
         {
            ipV4Suffix = /\.in-addr\.arpa$/;
            ipV6Suffix = /\.ip6\.arpa$/;
            ipV4Addr = /^\d{1,3}(\.\d{1,3}){3}$/;
            ipV6Addr = /^(::){0,1}[0-9a-f]{1,4}(:{1,2}[0-9a-f]{1,4}){0,7}(::){0,1}$/i;
            if(inHost.search(ipV4Suffix) != -1 || inHost.search(ipV6Suffix) != -1)
            {
               result = inHost;
            }
            else if(inHost.search(ipV4Addr) == 0)
            {
               byteMatcher = /\d+/g;
               bytes = inHost.match(byteMatcher);
               if(bytes != null && bytes.length == 4)
               {
                  arpa = new String();
                  while(bytes.length > 0)
                  {
                     arpa += bytes.pop();
                     arpa += ".";
                  }
                  result = arpa + "in-addr.arpa";
               }
            }
            else if(inHost.search(ipV6Addr) == 0)
            {
               colons = /(:+)/g;
               pieces = inHost.split(colons);
               numberOfPieces = pieces != null ? pieces.length : 0;
               if(numberOfPieces > 0 && numberOfPieces <= 15 && (numberOfPieces & 1) == 1)
               {
                  zerosToAdd = 15 - numberOfPieces >> 1;
                  piecesWithZeros = new Array();
                  ok = true;
                  while(ok && i < numberOfPieces)
                  {
                     piece = pieces.shift();
                     if(piece != ":")
                     {
                        if(piece == "::")
                        {
                           ok = zerosToAdd > 0;
                           if(ok)
                           {
                              while(Boolean(zerosToAdd--))
                              {
                                 piecesWithZeros.push("0000");
                              }
                           }
                        }
                        else
                        {
                           while(piece.length < 4)
                           {
                              piece = "0" + piece;
                           }
                           piecesWithZeros.push(piece);
                        }
                     }
                     i++;
                  }
                  if(ok && piecesWithZeros.length == 8)
                  {
                     runOn = piecesWithZeros.join("");
                     arpa = new String();
                     for(i = runOn.length - 1; i >= 0; i--)
                     {
                        arpa += runOn.charAt(i);
                        arpa += ".";
                     }
                     result = arpa + "ip6.arpa";
                  }
               }
            }
            else
            {
               result = null;
            }
         }
         return result;
      }
   }
}


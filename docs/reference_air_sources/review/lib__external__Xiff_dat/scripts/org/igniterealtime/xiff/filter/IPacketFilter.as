package org.igniterealtime.xiff.filter
{
   import org.igniterealtime.xiff.data.XMPPStanza;
   
   public interface IPacketFilter
   {
      
      function accept(param1:XMPPStanza) : void;
   }
}


package flash.security
{
   [API("661")]
   [native(cls="XMLSignatureEnvelopedTransformerClass",instance="XMLSignatureEnvelopedTransformerObject",methods="auto",construct="native")]
   internal class XMLSignatureEnvelopedTransformer
   {
      
      public function XMLSignatureEnvelopedTransformer()
      {
         super();
      }
      
      private native function dummyFunction() : void;
      
      public function transform(sig:XML, doc:XML) : XML
      {
         var oneCopySig:XML = null;
         var parentXML:XML = null;
         var theCopy:XML = doc.copy();
         var activeNamespace:Namespace = theCopy.namespace();
         var sigNamespace:Namespace = sig.namespace();
         var copySigs:XMLList = theCopy..sigNamespace::Signature;
         var hasSig:Boolean = copySigs.contains(sig);
         if(hasSig)
         {
            for each(oneCopySig in copySigs)
            {
               if(oneCopySig == sig)
               {
                  parentXML = oneCopySig.parent();
                  delete parentXML.children()[oneCopySig.childIndex()];
               }
            }
         }
         return theCopy;
      }
   }
}


global with sharing class CM_CSVIterator implements Iterator<string>, Iterable<string>
{
   private String m_CSVData;   
   Private static transient final string CARRIAGERETURN = '\r\n';
   
   public CM_CSVIterator(String fileData)
   {
      m_CSVData = fileData;
      
   }
   global Boolean hasNext()
   {
      return m_CSVData.length() > 1 ? true : false;
   }
   global String next()
   {
       system.debug('#######'+m_CSVData);
       system.debug('@@@@@@@@'+m_CSVData.indexOf(CARRIAGERETURN));
      String row = m_CSVData.subString(0, m_CSVData.indexOf(CARRIAGERETURN));
      m_CSVData = m_CSVData.subString(m_CSVData.indexOf(CARRIAGERETURN) + (CARRIAGERETURN).length(),m_CSVData.length());
      return row;
   }
   global Iterator<string> Iterator()
   {
      return this;   
   }
}
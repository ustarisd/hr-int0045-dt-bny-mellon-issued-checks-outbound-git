<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:bc="urn:com.workday/bc"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xtt="urn:com.workday/xtt"
    xmlns:wd="urn:com.workday/bsvc"
    xmlns:etv="urn:com.workday/etv" xmlns:out="http://www.workday.com/integration/output"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    version="2.0" exclude-result-prefixes="xsd xsl bc out">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Dec 3, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> Darren Ustaris</xd:p>
            <xd:p>INT0045 BNY Mellon Bank Issued Checks Document Transform XSLT</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>
            <xd:p> Set the output method to xml</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output method="xml" indent="yes"/>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Global Variables</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:variable name="CreationDate">
        <xsl:value-of select="format-dateTime(wd:Get_Payments_Response/wd:Response_Data[1]/wd:Payment[1]/wd:Payment_Data[1]/wd:Integration_Field_Override_Data[1]/wd:Value[1],'[Y01][M01][D01]')"/>
    </xsl:variable>
    <xsl:variable name="CreationTime">
        <xsl:value-of select="format-dateTime(wd:Get_Payments_Response/wd:Response_Data[1]/wd:Payment[1]/wd:Payment_Data[1]/wd:Integration_Field_Override_Data[1]/wd:Value[1],'[H01][m01]')"/>
    </xsl:variable>
    
    <xsl:variable name="CountAddCheck">
        <xsl:value-of select="count(wd:Get_Payments_Response/wd:Response_Data[1]/wd:Payment[1]/wd:Payment_Data[1]/wd:Payment_Group_Data[1]/wd:Payment_Type_Reference[1]/@wd:Descriptor='Check')"/>
    </xsl:variable>
    
    <xsl:variable name="SumAddCheck">
        <xsl:choose>
            <xsl:when test="wd:Get_Payments_Response/wd:Response_Data[1]/wd:Payment[1]/wd:Payment_Data[1]/wd:Payment_Group_Data[1]/wd:Payment_Type_Reference[1]/@wd:Descriptor='Check'">
                <xsl:value-of select="sum(wd:Get_Payments_Response/wd:Response_Data[1]/wd:Payment[1]/wd:Payment_Data[1]/wd:Payment_Amount)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:variable>
    
    
    <xsl:variable name="CountVoidCheck">
        <xsl:value-of select="count(wd:Get_Payments_Response/wd:Response_Data/wd:Payment/wd:Payment_Data/wd:Integration_Field_Override_Data[2]/wd:Value[2])"/>
    </xsl:variable>
    
    <xsl:variable name="SumVoidCheck">
        
        <xsl:value-of select="sum(wd:Get_Payments_Response/wd:Response_Data/wd:Payment/wd:Payment_Data/wd:Integration_Field_Override_Data[2]/wd:Value[2])"/>
        
    </xsl:variable>
    
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>General Description of the template</xd:p>
        </xd:desc>
        <xd:param name="Param1">Header Record - Record Type 1</xd:param>
        <xd:param name="Param2">Service Header Record - Record Type 2</xd:param>
        <xd:param name="Param3">Disbursement Record - Record Type 6</xd:param>
        <xd:param name="Param4">Payee Header Record - Record Type 8</xd:param>
        <xd:param name="Param5">Lien Header Record - Record Type 9</xd:param>
    </xd:doc>
    
    
    
    
    <xsl:template match="wd:Get_Payments_Response/wd:Response_Data/wd:Payment">
        
        <File >
            
            <!--<xd:desc>Header Record</xd:desc>-->
            <Header xtt:endTag="&#xA;">
                <RecordType xtt:fixedLength="1" xtt:attribute="Record Type 1"></RecordType>
                <Filler xtt:fixedLength="2"><xsl:text></xsl:text></Filler>
                <Destination xtt:fixedLength="10" xtt:attribute="Destination"></Destination>
                <CompanyName xtt:fixedLength="10" xtt:attribute="Company Name"></CompanyName>
                <TransmissionDate xtt:fixedLength="6"><xsl:value-of select="$CreationDate"/></TransmissionDate>
                <TransmmissionTime xtt:fixedLength="4"><xsl:value-of select="$CreationTime"/></TransmmissionTime>
                <filler xtt:fixedLength="47"></filler>
            </Header>
            
            
            <!--<xd:desc>Service Header Record</xd:desc>-->
            <ServiceHeader xtt:endTag="&#xA;">
                <RecordType xtt:fixedLength="1" xtt:attribute="Record Type 2"></RecordType>
                <Filler xtt:fixedLength="30" xtt:attribute="Record Type 2 Filler"><xsl:text></xsl:text></Filler>
                <ServiceType xtt:fixedLength="3" xtt:attribute="Service Type"></ServiceType>
                <RecordSize xtt:fixedLength="3" xtt:attribute="Record Size"></RecordSize>
                <BlockingFactor xtt:fixedLength="4" xtt:attribute="Blocking Factor"></BlockingFactor>
                <FormatCode xtt:fixedLength="1" xtt:attribute="Format Code"></FormatCode>
                <Filler xtt:fixedLength="38"></Filler>
            </ServiceHeader>
            
            
            <!--<xd:desc>Detail Header Record</xd:desc>-->
            <ServiceHeader xtt:endTag="&#xA;">
                <RecordType xtt:fixedLength="1" xtt:attribute="Record Type 5"></RecordType>
                <OriginCompanyName xtt:fixedLength="10" xtt:attribute="Origin Company Name"></OriginCompanyName>
                <DestinationReceivingLoc xtt:fixedLength="10" xtt:attribute="Destination Receiving Location"></DestinationReceivingLoc>
                <CheckingAccountNum xtt:fixedLength="10"><xsl:value-of select="wd:Payment_Data/wd:Receiving_Party_Bank_Data/wd:Account_Number"/></CheckingAccountNum>
                <Filler xtt:fixedLength="49"></Filler>
            </ServiceHeader>
            
            
            <xsl:for-each select="wd:Payment_Data">
                
                <!--<xd:desc>Disbursement Record</xd:desc>-->
                <DisbursementRecord xtt:endTag="&#xA;">
                    <RecordType xtt:fixedLength="1" xtt:attribute="Record Type 6"></RecordType>
                    <StatusCode xtt:fixedLength="1" xtt:attribute="Status Code"></StatusCode>
                    <CheckNumber xtt:fixedLength="10" xtt:align="right" xtt:paddingCharacter="0"><xsl:value-of select="wd:Payment_Reference_Number"/></CheckNumber>
                    <CheckAmount xtt:fixedLength="10" xtt:numberFormat="##########" xtt:align="right" xtt:paddingCharacter="0"><xsl:value-of select="wd:Payment_Amount*100"/></CheckAmount>
                    <IssueDate xtt:fixedLength="6" xtt:dateFormat="YYMMdd"><xsl:value-of select="wd:Payment_Group_Data/wd:Payment_Date"/></IssueDate>
                    <Filler xtt:fixedLength="94"></Filler>
                    <AdditionalData xtt:fixedLength="10"><!--<xsl:value-of select="wd:PAY_NUMBER"/>--></AdditionalData>
                    <RegisterInfo xtt:fixedLength="5" xtt:attribute="Primary Home Address"></RegisterInfo>
                    <Filler xtt:fixedLength="7"></Filler>
                </DisbursementRecord>
                
            </xsl:for-each>
            
            
            <!--ServiceTotal-->
            <PayeeHeaderRecord xtt:endTag="&#xA;">
                <RecordType xtt:fixedLength="1"><xsl:text>8</xsl:text></RecordType>
                <TotalNumberofAdd xtt:fixedLength="10" xtt:align="right" xtt:paddingCharacter="0">
                    <xsl:choose>
                        <xsl:when test="$CountAddCheck=''">
                            <xsl:text>0</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$CountAddCheck"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </TotalNumberofAdd>
                <TotalDollarAmountAdd xtt:fixedLength="12" xtt:numberFormat="##########" xtt:align="right" xtt:paddingCharacter="0">
                    <xsl:choose>
                        <xsl:when test="$SumAddCheck=''">
                            <xsl:text>0</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$SumAddCheck*100"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    
                </TotalDollarAmountAdd>
                <TotalNumberofVoid xtt:fixedLength="10" xtt:align="right" xtt:paddingCharacter="0"><xsl:value-of select="$CountVoidCheck"/></TotalNumberofVoid>
                <TotalDollarAmountVoid xtt:fixedLength="12" xtt:numberFormat="##########" xtt:align="right" xtt:paddingCharacter="0"><xsl:value-of select="$SumVoidCheck*100"/></TotalDollarAmountVoid>
                <Filler xtt:fixedLength="35"></Filler>
            </PayeeHeaderRecord>
            
            
            <!--<xd:desc>Lien Header Record</xd:desc>-->
            <LienHeaderRecord xtt:endTag="&#xA;">
                <RecordType xtt:fixedLength="1" xtt:attribute="Record Type 9"></RecordType>
                <TotalNumberofAdd xtt:fixedLength="6" xtt:align="right" xtt:paddingCharacter="0"><xsl:value-of select="$CountAddCheck"/></TotalNumberofAdd>
                <Filler xtt:fixedLength="73"></Filler>
            </LienHeaderRecord>
            
            
        </File>
    </xsl:template>
    
    
</xsl:stylesheet>



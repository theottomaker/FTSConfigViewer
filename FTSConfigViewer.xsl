<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--*********This stylesheet is for automated formatting of FTS configuration files .xml file ********-->
<!-- Water Survey of Canada FTS StyleSheet v 2.3 -->
<!-- Developed 2018-12-07 -->
<!-- ottO Bédard, MSc - North Bay, Ontario - otto.bedard@canada.ca -->
<!-- Updates

v 2.3
- Minor Formatting changes

v 2.2
- Adjusted Burst Averaging
- Change Time Bias to GMT Offset
- Expanded Telemetry Summary
- Greatly expanded Sensor Details
- Formatting changes
- Changes to Visit Report Formatting

v 2.1
- Extended Visit Report Information
- Minor Formatting

v 2.0
- Added End Visit Report information

v 1.5
- Added Delta Process information
- Added Process Type information
- Added Script Process breakout
- Added Averaging Field information
- Added MaxMin Process

-->

<xsl:template match="/">

<html>

<head>

<style>

<!-- sticky floating div -->
div.sticky {
    position: -webkit-sticky; /* Safari */
    position: sticky;
    top: 0;
    background-color: white;
    border: 3px solid #CC66CC;
}

 <!-- rest of the document styling -->
table {
	border: 2px solid black;
	
	border-collapse: collapse;
}

table.station{
	border: 1px solid white;

}

th {
    font-size:1.1em;
	text-align: center;
	vertical-align: center;
	background-color:#CDCDCD;
	height:20px;
	border-bottom: 1px solid black;
	padding:7px;
	
}

th.spanner
 {
    font-size:1.1em;
	text-align: center;
	vertical-align: center;
	background-color:#CDCDCD;
	height:20px;
	border-bottom: 1px solid black;
	border-left: 2px solid black;
	border-right: 2px solid black;
	padding:7px;
	
}

tr, td{
	border-bottom: 1px solid black;
	text-align: center;
	padding: 5px;
}
tr:hover {background-color:#CCFF66;}

td.station{
	border: 1px solid white;
	height: 25px;
	
	font-size: 1.75em;
	font-weight: bold;
	text-align: left;
	
}

td.Command
{
	border-bottom: 1px solid black;
	text-align: left;
	padding: 5px;
}


h2{
	font-size: 1.75em;
	font-weight: bold;

}

h3{
	font-size: 1.5em;
	font-weight: bold;

}

<!-- Colourize each section -->

section.station
{
  border-top: #FFFFFF;
	border-bottom: #FFFFFF;
	border-left:15px #CC66CC;
	border-right: #FFFFFF;
	border-style: solid;
	padding-bottom: 3px;
	padding-left: 5px;
}

section.visitreport
{
  border-top: #FFFFFF;
	border-bottom: #FFFFFF;
	border-left:15px #AAAAAA;
	border-right: #FFFFFF;
	border-style: solid;
	padding-bottom: 3px;
	padding-left: 5px;
}

section.telemetry
{
  border-top: #FFFFFF;
	border-bottom: #FFFFFF;
	border-left:15px #119911;
	border-right: #FFFFFF;
	border-style: solid;
	padding-bottom: 3px;
	padding-left: 5px;
}

section.sensors{
    border-top: #FFFFFF;
	border-bottom: #FFFFFF;
	border-left: 15px #0099CC;
	border-right: #FFFFFF;
	border-style: solid;
	padding-bottom: 3px;
	padding-left: 5px;
}
section.processes
{
    border-top: #FFFFFF;
	border-bottom: #FFFFFF;
	border-left:15px #CCCC00;
	border-right: #FFFFFF;
	border-style: solid;
	padding-bottom: 3px;
	padding-left: 5px;
}
section.log
{
    border-top: #FFFFFF;
	border-bottom: #FFFFFF;
	border-left:15px #8B4513;
	border-right: #FFFFFF;
	border-style: solid;
	padding-bottom: 3px;
	padding-left: 5px;
}


section.versions
{
    border-top: #FFFFFF;
	border-bottom: #FFFFFF;
	border-left:15px #AA0000;
	border-right: #FFFFFF;
	border-style: solid;
	padding-bottom: 3px;
	padding-left: 5px;
}
</style>


</head>
<body>

<!-- Station Information -->
<!-- Floating station information -->
<div class="sticky">
	<table class="station">
		<tr>
		<td class="station">Station Number:</td>
		<td class="station"> <xsl:value-of select="//@StationName"/></td>
		</tr>
		<tr>
		<td class="station">Station Name:</td>
		<td class="station"><xsl:value-of select="//@StationDescription"/>
		</td>
		</tr>

	</table>
	</div>

<section class="station">
<article>
		
	<!-- test for Lat/Long Information -->
	<xsl:choose>
		<xsl:when test="//@StationLatitude > 0">
			<xsl:variable name="link">
				<xsl:text>https://www.google.com/maps/search/?api=1<![CDATA[&]]>query=</xsl:text>
				<xsl:value-of select="//@StationLatitude"/>
				<xsl:text>,</xsl:text>
				<xsl:value-of select="//@StationLongitude"/>
			</xsl:variable>		
			<p>Latitude: <xsl:value-of select="//@StationLatitude"/> Longitude: <xsl:value-of select="//@StationLongitude"/>  <a href="{$link}" target="_blank"> Google Maps</a></p>
			</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>

	<!-- Station time zone information -->
	<table>
		<tr>
			<th>Standard Time Zone</th>
			<td><xsl:value-of select="//@Name"/></td>
			
			<th>GMT Offset</th>
			<td>-
			<!-- Convert the TimeZoneInfo Bias from minutes! into HH:MM:SS -->
			<xsl:variable name="seconds" select="//@Bias*60" />

			<xsl:value-of select="format-number(floor($seconds div 3600), '00')" />
			<xsl:value-of select="format-number(floor($seconds div 60) mod 60, ':00')"/>
			<xsl:value-of select="format-number($seconds mod 60, ':00')"/>
			
			</td>
		</tr>

	</table>


</article>
</section>

<!-- Visit Report Information -->
<!-- Test for Visit Report -->
<xsl:if test="/XMLRoot/VisitReport">
    <section class="visitreport">
      <article class="content">
        <h3>Visit Report Supplement</h3>

          <table>
            <tr>
              <th>Logger Model</th>
              <th>Version</th>
              <th>Serial #</th>
              <th>OS Ver</th>
              <th>AS Ver</th>
              <th>Device 1</th>
              <th>Standard</th> 
              <th>Serial #</th>
              <th>SW Ver</th>
              <th>Ant Bearing</th>
              <th>Ant Inclin</th>
              <th>Device 2</th>            
            </tr>
            <tr>
              <td><xsl:value-of select="/XMLRoot/VisitReport/@LoggerModel"/></td> 
              <td><xsl:value-of select="/XMLRoot/VisitReport/@LoggerVersion"/></td> 
				
					
              <td><xsl:value-of select="substring-before(/XMLRoot/VisitReport/@SerialNumber,',')"/><br/>
			  <xsl:value-of select="substring-after(/XMLRoot/VisitReport/@SerialNumber,',')"/></td>

              <td><xsl:value-of select="/XMLRoot/VisitReport/@OSVersion"/></td> 

			  <td><xsl:value-of select="substring-before(/XMLRoot/VisitReport/@SoftwareVersion,',')"/><br/>
			  <xsl:value-of select="substring-after(/XMLRoot/VisitReport/@SoftwareVersion,',')"/></td>

              <td><xsl:value-of select="/XMLRoot/VisitReport/@DeviceType"/></td> 
              <td><xsl:value-of select="/XMLRoot/VisitReport/@Standard"/></td> 
              <td><xsl:value-of select="/XMLRoot/VisitReport/@Serial"/></td>
              
			  <td><xsl:value-of select="substring-before(/XMLRoot/VisitReport/@SWVer,' ')"/><br/>
			  <xsl:value-of select="substring-after(/XMLRoot/VisitReport/@SWVer,' ')"/></td>
			  
              <td><xsl:value-of select="substring-before(/XMLRoot/VisitReport/@AntennaBearing,',')"/></td>
			  
			  <td><xsl:value-of select="/XMLRoot/VisitReport/@AntennaInclination"/>
			  
			  
			  
			  </td> 
              <td><xsl:value-of select="/XMLRoot/VisitReport/@DeviceType2"/></td> 
            </tr>
          </table>  

      </article>
    </section>
  </xsl:if>
  
    
<!-- Telemetry Information -->
<!-- Test for Telemetry -->
<xsl:if test="/XMLRoot/Telems">
	<section class="telemetry">
		<article class="content">

		
		
	<!-- Find out what type of TELEM we are working with -->
	<xsl:for-each select="/XMLRoot/Telems/*">
		<xsl:variable name="isG5"><xsl:value-of select="@TelemType"/></xsl:variable>
		
	
	<!-- If this is a G5 or G6, do satellite output -->
	<xsl:if test="$isG5='G5' or $isG5='G6'">
		
		<h3 class="telemetry">Satellite Telemetry Summary<br/>Active Transmitter -
		<xsl:value-of select="$isG5"/></h3>
		
	<table>
		<!-- Header information -->
		<tr>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th></th>
			<th colspan="8" class="spanner">Self Timed Transmissions</th>
			<th colspan="4" class="spanner">Random Transmissions</th>
			<th colspan="3" class="spanner">Power Settings dBm</th>
		</tr>
		<tr>
			<th>Telem Type</th>
			<th>Network</th>
			<th>NesID</th>
			<th>Standard</th>
			<th>Format</th>
			<!-- Self Timed -->
			<th>Enabled</th>
			<th>Interval</th>
			<th>BitRate</th>
			<th>1stTrans</th>
			<th>Window</th>
			<th>Chnl</th>
			<th>Centering</th>
			<th>Sat</th>
			<!-- Random -->	
			<th>Enabled</th>
			<th>BitRate</th>
			<th>Chnl</th>
			<th>Repeat Cnt</th>
			<!-- Power Setting -->
			<th>100bps</th>
			<th>300bps</th>
			<th>1200bps</th>
			
			
		</tr>

	<xsl:for-each select="*">
	  <tr>
		<td><xsl:value-of select="local-name()"/></td>
		<td><xsl:value-of select="@SatelliteNetwork"/></td>
		<td><xsl:value-of select="@NesID"/></td>
		<td><xsl:value-of select="@Standard" /></td>
		<td><xsl:value-of select="@MsgFormat" /></td>
		<td><xsl:value-of select="@SelfTimedEnabled" /></td>
		<td>
		<!-- Convert the Interval from seconds into HH:MM:SS -->
		<xsl:variable name="seconds" select="@SelfTimedInterval" />

		<xsl:value-of select="format-number(floor($seconds div 3600), '00')" />
		<xsl:value-of select="format-number(floor($seconds div 60) mod 60, ':00')"/>
		<xsl:value-of select="format-number($seconds mod 60, ':00')"/></td>
		
		
		
		<td><xsl:value-of select="@SelfTimedBitrate"/></td>
		
		<!-- Convert the First Transmit Time from seconds into HH:MM:SS -->
		<xsl:variable name="seconds" select="@SelfTimed1stTrans" />

		<td><xsl:value-of select="format-number(floor($seconds div 3600), '00')" />
		<xsl:value-of select="format-number(floor($seconds div 60) mod 60, ':00')"/>
		<xsl:value-of select="format-number($seconds mod 60, ':00')"/></td>
			
		<td>00:00:<xsl:value-of select="@SelfTimedWin" /></td>
		<td><xsl:value-of select="@SelfTimedChannel" /></td>
		<td><xsl:value-of select="@SelfTimedMsgCenter" /></td>
		
		<td><xsl:value-of select="@Satellite" /></td>
		<!-- Random Transmissions -->
		<td><xsl:value-of select="@RandomEnabled"/></td>
		<td><xsl:value-of select="@RandomBitrate"/></td>
		<td><xsl:value-of select="@RandomChannel"/></td>
		<td><xsl:value-of select="@RandomRepeatCount"/></td>
		
		<td><xsl:value-of select="@PowerLevel100bps"/></td>
		<td><xsl:value-of select="@PowerLevel300bps"/></td>
		<td><xsl:value-of select="@PowerLevel1200bps"/></td>
		
	  </tr>
	</xsl:for-each>
	</table>
		
	<h3>Message Information</h3>
	<table>
	<tr>
		<th>Telem Type</th>
		<th>Variable</th>
		<th>Interval</th>
		<th>Offset</th>
		<th>Red. Recs (#)</th>
	</tr>
	<xsl:for-each select="/XMLRoot/Telems/*/*/SelfTimed/*/*">
	<tr>
		<xsl:if test="name(../../..)=$isG5">
			<td><xsl:value-of select="name(../../..)"/></td>
			<td><xsl:value-of select="@Input"/></td>
			<td>
				<!-- Convert the Interval from seconds into HH:MM:SS -->
				<xsl:variable name="seconds" select="@Interval" />

				<xsl:value-of select="format-number(floor($seconds div 3600), '00')" />
				<xsl:value-of select="format-number(floor($seconds div 60) mod 60, ':00')"/>
				<xsl:value-of select="format-number($seconds mod 60, ':00')"/></td>
			
			<td>
				<!-- Convert the Offset from seconds into HH:MM:SS -->
				<xsl:variable name="seconds" select="@Offset" />

				<xsl:value-of select="format-number(floor($seconds div 3600), '00')" />
				<xsl:value-of select="format-number(floor($seconds div 60) mod 60, ':00')"/>
				<xsl:value-of select="format-number($seconds mod 60, ':00')"/></td>
				
			<td><xsl:value-of select="@RedundantRecs"/></td>
		</xsl:if>
	</tr>
	</xsl:for-each>	
		
	</table>
	
	<!-- end of G5/G6 -->
	</xsl:if>
	
	<!-- add test for DB9 -->
	<xsl:if test="$isG5='DB9'">
	
	<h3 class="telemetry">DB9 Telemetry Summary</h3>
	
	<table>
		<tr>
			<th>Telem Type</th>
			<th>Baudrate</th>
			<th>DataBits</th>
			<th>StopBits</th>
			<th>Parity</th>
			<th>FlowControl</th>
			<th>Wake Up Delay (ms)</th>
			<th>Ack TO (s)</th>
			<th>CtsActive TO (s)</th>
			<th>Power Cycle</th>
			<th>PC Int (s)</th>
			<th>PC Offset (s)</th>
			<th>Off Time (s)</th>
		</tr>
		
	<xsl:for-each select="*">
	  <tr>
		<td><xsl:value-of select="local-name()"/></td>
		<td><xsl:value-of select="@Baudrate" /></td>
		<td><xsl:value-of select="@DataBits" /></td>
		<td><xsl:value-of select="@StopBits" /></td>
		<td><xsl:value-of select="@Parity" /></td>
		<td><xsl:value-of select="@FlowControl"/></td>
		<td><xsl:value-of select="@WakeupDelayMs"/></td>
		<td><xsl:value-of select="@AckTimeoutSeconds"/></td>
		<td><xsl:value-of select="@CtsActiveTimeoutSeconds"/></td>
		<td><xsl:value-of select="@PowerCycleEnabled"/></td>
		<td><xsl:value-of select="@PowerCycleInterval"/></td>
		<td><xsl:value-of select="@PowerCycleOffset" /></td>
		<td><xsl:value-of select="@PowerOffTime" /></td>

	  </tr>
	</xsl:for-each>
	</table>
	
	
	
	<!-- end of DB9 -->
	</xsl:if>
	
	<!-- end of telems -->
	
	</xsl:for-each>
	
	</article>
    </section>
</xsl:if>


<!-- Sensors Information -->
<section class="sensors">
<article>
	<h3>Sensors</h3>

<table>
	<tr>
		<th>Label</th>
		<th>Type</th>
		<th>Enabled</th>
		<th>Port</th>
		<th>Addr.</th>
		<th>Units</th>
		<th>Hardware ID</th>
		<th>Commands</th>
		<th>Interval</th>
		<th>Offset</th>
		<th>Burst Samples</th>
		<th>Burst Time</th>
		<th>Command Summaries</th>
		</tr>

<xsl:for-each select="/XMLRoot/Sensors/*">
  <tr>
    <td><xsl:value-of select="local-name()"/></td>
    <td><xsl:value-of select="@SensorType" /></td>
	<td><xsl:value-of select="@SensorOn" /></td>
	<td><xsl:value-of select="@Port" /></td>
	<td><xsl:value-of select="@Address" /></td>
	<td><xsl:value-of select="@Units" /></td>
	<td><xsl:value-of select="@HardwareID" /></td>
	<!-- there is likely more than one command -->
	<td>
		<xsl:for-each select="current()/*">	
		<xsl:value-of select="@CmdName" /><br/>		
		</xsl:for-each>
	</td>
		
	<!-- test for an interval, cycle through all the possible intervals -->
	<td>
		<xsl:for-each select="current()/*">	
				
			<xsl:if test="@CmdInterval">
				<!-- Convert the Interval Time from seconds into HH:MM:SS -->
				<xsl:variable name="second" select="@CmdInterval" />

				<xsl:value-of select="format-number(floor($second div 3600), '00')" />
				<xsl:value-of select="format-number(floor($second div 60) mod 60, ':00')"/>
				<xsl:value-of select="format-number($second mod 60, ':00')"/>
			</xsl:if>
			
			<br/>
		
		</xsl:for-each>
	</td>
	
	<!-- test for an offset -->
	<td>

		<xsl:for-each select="current()/*">
		
			<xsl:if test="@CmdOffset">
				<!-- Convert the Offset Time from seconds into HH:MM:SS -->
				<xsl:variable name="seconds" select="@CmdOffset" />

				<xsl:value-of select="format-number(floor($seconds div 3600), '00')" />
				<xsl:value-of select="format-number(floor($seconds div 60) mod 60, ':00')"/>
				<xsl:value-of select="format-number($seconds mod 60, ':00')"/>
			</xsl:if>
			
			<br/>
		
		</xsl:for-each>
		
	</td>
	
	<!-- Burst Averaging Information -->
	<td><xsl:value-of select="current()//@CmdNumberOfSamples"/>
	</td>
	<td>
    <!-- Convert the Offset Time from seconds into HH:MM:SS -->
    <xsl:variable name="seconds" select="current()//@CmdSamplePeriod" />

    <xsl:value-of select="format-number(floor($seconds div 3600), '00')" />
    <xsl:value-of select="format-number(floor($seconds div 60) mod 60, ':00')"/>
    <xsl:value-of select="format-number($seconds mod 60, ':00')"/>
	</td>
	
	

	<td class="Command">
		<!-- Test what we are dealing with, add supplemental information 
			Add each sensor type separately here -->
		
		
		<!-- Case Temp Sensor -->
		<xsl:if test="@SensorType='CaseTempSensor'">			
			Case Temp Sensor Variable:<xsl:value-of select="@VariableName"/>
		</xsl:if>
		
		<!-- Battery Sensor -->
		<xsl:if test="@SensorType='BatterySensor'">			
			Battery Voltage:<xsl:value-of select="@BvName"/><br/>
			Battery Current:<xsl:value-of select="@BiName"/><br/>
			Battery Temp:<xsl:value-of select="@BtName"/><br/>
			Battery Temp Units:<xsl:value-of select="@BtUnits"/>
		</xsl:if>
		
		
		<!-- PC Gauge Sensor -->
		<xsl:if test="@SensorType='RainSensor'">			
			Variable Name:<xsl:value-of select="@VariableName"/><br/>
			Auto Reset Enabled:<xsl:value-of select="@AutoResetEnabled"/><br/>
			Tip Increment:<xsl:value-of select="@TipInc"/>
		</xsl:if>
		
		<!-- Solar Sensor -->
		<xsl:if test="@SensorType='SolarSensor'">			
			Voltage Variable:<xsl:value-of select="@BvName"/><br/>
			Current Variable:<xsl:value-of select="@BiName"/>
		</xsl:if>
		
		<!-- Test for Commands within the sensors -->
		<xsl:if test="current()/*/*">
		<table width="100%" cellspacing="0.5">
			<tr>
			<th>CMD</th>
			<th>Var Name</th>
			<th>Units</th>
			<th>Precision</th>
			<th>Offset</th>
			<th>FieldNum</th>
			</tr>
			<xsl:for-each select="current()/*/*">
			<tr>
				<td><xsl:value-of select="../@CmdName"/></td>
				<td><xsl:value-of select="local-name()"/></td>
				<td><xsl:value-of select="@FieldUnits"/></td>
				<td><xsl:value-of select="@FieldPrecision"/></td>
				<td><xsl:value-of select="@FieldOffset"/></td>
				<td><xsl:value-of select="@FieldNum"/></td>
			</tr>
			</xsl:for-each>
		</table>
		</xsl:if>
	</td>
  </tr>
</xsl:for-each>
</table>

<!-- put the SDI-AM content in two cells, for the photo -->
	<!-- let's explode out an SDI-AM to get all the details -->
	<xsl:for-each select="/XMLRoot/Sensors/*">
	
	
		<xsl:if test="local-name()='SDI_AM'">
		<h3>SDI-AM Setup</h3>
		
		<!-- Analog Channels -->
		<table>
			<tr>
				<th>Analog Channel</th>
				<th>Mode</th>
				<th>Name</th>
				<th>Range</th>
				<th></th>
			
			</tr>
			<tr>
				<td>1</td>
				<td><xsl:value-of select="@Analog1Mode" /></td>
				<td><xsl:value-of select="@Analog1Name" /></td>				
				<td><xsl:value-of select="@Analog1Range" /></td>
				<td rowspan="4"><a href="https://ftsinc.com/wp-content/uploads/2015/07/Axiom-Analog-Interface-Module.jpg" target="_blank"><img src="https://ftsinc.com/wp-content/uploads/2015/07/Axiom-Analog-Interface-Module.jpg" width="125" alt="FTS SDI-AM - please connect to the internet to see the photo"/></a></td>
			</tr>
			<tr>
				<td>2</td>
				<td><xsl:value-of select="@Analog2Mode" /></td>
				<td><xsl:value-of select="@Analog2Name" /></td>
				<td><xsl:value-of select="@Analog2Range" /></td>
			</tr>
			<tr>
				<td>3</td>
				<td><xsl:value-of select="@Analog3Mode" /></td>
				<td><xsl:value-of select="@Analog3Name" /></td>
				<td><xsl:value-of select="@Analog3Range" /></td>
			</tr>
			<tr>
				<td>4</td>
				<td><xsl:value-of select="@Analog4Mode" /></td>
				<td><xsl:value-of select="@Analog4Name" /></td>
				<td><xsl:value-of select="@Analog4Range" /></td>
			</tr>
		</table>
		<p/>
	
		<!-- Powered Channels -->
		<table>
			<tr>
				<th>Powered Channel</th>
				<th>Mode</th>
				<th>Warm-up</th>
				<th>Cycle Every</th>
				<th>Cycle For</th>
			</tr>
			<tr>
				<td>1</td>
				<td><xsl:value-of select="@Power1Mode" /></td>
				<td><xsl:value-of select="@Power1WarmUp" /></td>
				<td><xsl:value-of select="@Power1CycleEvery" /></td>
				<td><xsl:value-of select="@Power1CycleFor" /></td>
			</tr>
			<tr>
				<td>2</td>
				<td><xsl:value-of select="@Power2Mode" /></td>
				<td><xsl:value-of select="@Power2WarmUp" /></td>
				<td><xsl:value-of select="@Power2CycleEvery" /></td>
				<td><xsl:value-of select="@Power2CycleFor" /></td>
			</tr>
		</table>
		<p/>
		<!-- Excitation Channels -->
		<table>
			<tr>
				<th>Excitation Channel</th>
				<th>Mode</th>
				<th>Warm-up</th>
				<th>Volts</th>
			</tr>
			<tr>
				<td>1</td>
				<td><xsl:value-of select="@Ex1Mode" /></td>
				<td><xsl:value-of select="@Ex1WarmUp" /></td>
				<td><xsl:value-of select="@Ex1Volts" /></td>
			</tr>
			<tr>
				<td>2</td>
				<td><xsl:value-of select="@Ex2Mode" /></td>
				<td><xsl:value-of select="@Ex2WarmUp" /></td>
				<td><xsl:value-of select="@Ex2Volts" /></td>
			</tr>
		</table>
		<p/>
		<!-- Counters -->
		<table>
			<tr>
				<th>Input Count</th>
				<th>Periodic Count</th>
				<th>Periodic Reset</th>
				<th>Switch State (SS)</th>
				<th>SS 0 Units</th>
				<th>SS 1 Units</th>
			</tr>		
			<tr>
				<td><xsl:value-of select="@InputCount" /></td>
				<td><xsl:value-of select="@PeriodicCount" /></td>
				<td><xsl:value-of select="@PeriodicReset" /></td>
				<td><xsl:value-of select="@SwitchState" /></td>
				<td><xsl:value-of select="@SwitchStateUnits0" /></td>
				<td><xsl:value-of select="@SwitchStateUnits1" /></td>
			</tr>		
		</table>
		
		<p/>
		<!-- Commands -->
		</xsl:if>
	
	</xsl:for-each>

</article>
</section>

<!-- Processes Information -->
<!-- Test for Processes -->
<xsl:if test="/XMLRoot/Processes">
<section class="processes">
<article>
<h3>Processes</h3>

<table>
	<tr>
		<th>Process Name</th>
		<th>Type</th>
		<th>Interval</th>
		<th>Offset</th>
		<th>Equation</th>
		<th>Precision</th>
		<th>Units</th>
		<th>Additional Info</th>
	</tr>
	
	<xsl:for-each select="/XMLRoot/Processes/*">
	
	<tr>
		<td><xsl:value-of select="local-name()"/></td>
		<td><xsl:value-of select="@ProcessType"/></td>
		<td>
		
			<xsl:if test="@Interval">
				<!-- Convert the Offset Time from seconds into HH:MM:SS -->
				<xsl:variable name="seconds" select="@Interval" />

				<xsl:value-of select="format-number(floor($seconds div 3600), '00')" />
				<xsl:value-of select="format-number(floor($seconds div 60) mod 60, ':00')"/>
				<xsl:value-of select="format-number($seconds mod 60, ':00')"/>
			</xsl:if>
			
		</td>
		<td>
			<xsl:if test="@Offset">
				<!-- Convert the Offset Time from seconds into HH:MM:SS -->
				<xsl:variable name="seconds" select="@Offset" />

				<xsl:value-of select="format-number(floor($seconds div 3600), '00')" />
				<xsl:value-of select="format-number(floor($seconds div 60) mod 60, ':00')"/>
				<xsl:value-of select="format-number($seconds mod 60, ':00')"/>
			</xsl:if>
		</td>
		<td class="process"><xsl:value-of select="@Equation"/></td>
		<td><xsl:value-of select="@Precision"/></td>
		<td><xsl:value-of select="@Units"/></td>
		<td class="process">
		<!-- This section is a catch all for various Process Types !!-->
		<!-- Test for the various kinds of information -->
		
		<!-- Let's deal with Scripts -->
		<xsl:if test="@Script">		
			Script:<xsl:value-of select="@Script"/>
		</xsl:if>
		
		<!-- Max/Min functions -->
		<xsl:if test="@ProcessType='MaxMinProcess'">
				Max Name:<xsl:value-of select="@MaxName"/><br/>
				Min Name:<xsl:value-of select="@MinName"/><br/>
				Input:<xsl:value-of select="@Input"/><br/>
				Reset Interval:<xsl:value-of select="@ResetInterval"/><br/>
				Reset Offset:<xsl:value-of select="@ResetOffset"/><br/>
				Use Time Stamp:<xsl:value-of select="@UseOccuranceTimeStamp"/>
		</xsl:if>
		
		<!-- Averaging functions -->
		<xsl:if test="@ProcessType='AvgProcess'">
				Input Variable:<xsl:value-of select="@Input"/><br/>
				Mean Name:<xsl:value-of select="@MeaName"/><br/>
				Max Name:<xsl:value-of select="@MaxName"/><br/>
				Min Name:<xsl:value-of select="@MinName"/><br/>
				Delta Name:<xsl:value-of select="@DeltaName"/><br/>
				Include Negative Delta?:<xsl:value-of select="@IncludeNegativeDelta"/><br/>
				Filter Length:<xsl:value-of select="@FilterLen"/>s
		</xsl:if>
		
		<!-- Delta functions -->
		<xsl:if test="@ProcessType='DeltaProcess'">
				Delta Name:<xsl:value-of select="@DeltaName"/><br/>
				Input Variable:<xsl:value-of select="@Input"/><br/>
				Reset Interval:<xsl:value-of select="@ResetInterval"/><br/>
				Reset Offset:<xsl:value-of select="@ResetOffset"/><br/>
				Allow Negative?:<xsl:value-of select="@AllowNeg"/>
		</xsl:if>
		
		
		</td>
	</tr>
	</xsl:for-each>	

</table>

</article>
</section>
</xsl:if>



<!-- Log Interval Information -->
<section class="log">
<article>

<h3>Log Intervals</h3>

<table>
	<tr>
		<th>Label</th>
		<th>Variables</th>
		<th>Interval</th>
		<th>Offset</th>
		</tr>

<xsl:for-each select="/XMLRoot/Loggers/*">
  <tr>
    <td><xsl:value-of select="local-name()"/></td>
	<td><xsl:for-each select="current()/*">
	<xsl:value-of select="local-name()"/><br/></xsl:for-each></td>
	<td>
		<!-- Convert the LoggerInterval from seconds into HH:MM:SS -->
			<xsl:variable name="seconds" select="@LoggerInterval" />

			<xsl:value-of select="format-number(floor($seconds div 3600), '00')" />
			<xsl:value-of select="format-number(floor($seconds div 60) mod 60, ':00')"/>
			<xsl:value-of select="format-number($seconds mod 60, ':00')"/>

	</td>
	<td>
		<!-- Convert the Loggeroffset from seconds into HH:MM:SS -->
			<xsl:variable name="seconds" select="@LoggerOffset" />

			<xsl:value-of select="format-number(floor($seconds div 3600), '00')" />
			<xsl:value-of select="format-number(floor($seconds div 60) mod 60, ':00')"/>
			<xsl:value-of select="format-number($seconds mod 60, ':00')"/>

	</td>
  </tr>
</xsl:for-each>
</table>
</article>
</section>

<!-- Ending version information -->

<section class="versions">
<article>
	
	<p>Created from: <div id="file"></div> on <div id="curtime"></div></p>
		
	<p> Water Survey of Canada - 	Style Sheet Version 2.2 - 2018-12-05</p>
	
	<script>		
		document.getElementById("curtime").innerHTML = Date();
		document.getElementById("file").innerHTML = location.pathname.substring(location.pathname.lastIndexOf("/") + 1);
	</script> 
	
</article>
</section>




</body>
</html>

</xsl:template>
</xsl:stylesheet>

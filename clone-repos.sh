#!/bin/sh
codeBaseDir=~/programming

#
# Creating my code directories
#    
mkdir -p $codeBaseDir
mkdir -p $codeBaseDir/github

#
# Github clone repositories 
#
mkdir -p $codeBaseDir/github/Awesome
mkdir -p $codeBaseDir/github/Azure
mkdir -p $codeBaseDir/github/AzureAD
mkdir -p $codeBaseDir/github/Architecture
mkdir -p $codeBaseDir/github/AspNet
mkdir -p $codeBaseDir/github/Benchmark
mkdir -p $codeBaseDir/github/OfficeDev
mkdir -p $codeBaseDir/github/CloudFoundry
mkdir -p $codeBaseDir/github/dx
mkdir -p $codeBaseDir/github/HDInsight
mkdir -p $codeBaseDir/github/mezmicrosoft-ml
mkdir -p $codeBaseDir/github/solarized
mkdir -p $codeBaseDir/github/Messaging
mkdir -p $codeBaseDir/github/Mobile
mkdir -p $codeBaseDir/github/Scaffolding

mkdir -p $codeBaseDir/github/Trading
mkdir -p $codeBaseDir/github/Trading/Quant
mkdir -p $codeBaseDir/github/Trading/API
mkdir -p $codeBaseDir/github/Trading/Data
mkdir -p $codeBaseDir/github/Trading/Algo
mkdir -p $codeBaseDir/github/Trading/Pricing
mkdir -p $codeBaseDir/github/Trading/Risk

mkdir -p $codeBaseDir/github/Finance
mkdir -p $codeBaseDir/github/Finance/Accounting
mkdir -p $codeBaseDir/github/Finance/API
mkdir -p $codeBaseDir/github/Finance/Homebanking
mkdir -p $codeBaseDir/github/MicroService
mkdir -p $codeBaseDir/github/MicroService/samples/SmartHotel360
mkdir -p $codeBaseDir/github/MicroService/samples/vertx
mkdir -p $codeBaseDir/github/csharp

cd $codeBaseDir/github/Azure
git clone https://github.com/Azure/api-management-samples.git
git clone https://github.com/Azure/azure-batch-samples.git
git clone https://github.com/Azure/Azure-DataFactory.git
git clone https://github.com/Azure/Azure-Media-Services-Explorer.git
git clone https://github.com/Azure/azure-media-services-samples.git
git clone https://github.com/Azure/azure-mobile-apps-quickstarts.git
git clone https://github.com/Azure/azure-mobile-engagement-samples.git
git clone https://github.com/Azure/azure-mobile-services-quickstarts.git
git clone https://github.com/Azure/azure-notificationhubs-samples.git
git clone https://github.com/Azure/azure-quickstart-templates.git
git clone https://github.com/Azure/azure-resource-manager-schemas.git
#git clone https://github.com/Azure/azure-service-bus-samples.git
git clone https://github.com/Azure/azure-sql-database-samples.git
git clone https://github.com/Azure/azure-stream-analytics.git
git clone https://github.com/Azure/Azure-vpn-config-samples.git
git clone https://github.com/Azure/azure-webjobs-quickstart.git
git clone https://github.com/Azure/azure-webjobs-sdk-samples.git
git clone https://github.com/Azure/AzureAD-BYOA-Provisioning-Samples.git
git clone https://github.com/Azure/AzureQuickStartsProjects.git
git clone https://github.com/Azure/BillingCodeSamples.git
git clone https://github.com/Azure/elastic-db-tools.git
git clone https://github.com/Azure/identity-management-samples.git

cd $codeBaseDir/github/AzureAD
git clone https://github.com/Azure-Samples/active-directory-dotnet-graphapi-console.git
git clone https://github.com/Azure-Samples/active-directory-java-graphapi-web.git
git clone https://github.com/Azure-Samples/active-directory-angularjs-singlepageapp-dotnet-webapi.git
git clone https://github.com/Azure-Samples/active-directory-android.git
git clone https://github.com/Azure-Samples/active-directory-dotnet-webapp-webapi-openidconnect-aspnetcore.git
git clone https://github.com/Azure-Samples/active-directory-dotnet-webapi-onbehalfof.git
git clone https://github.com/Azure-Samples/active-directory-dotnet-native-headless.git
git clone https://github.com/Azure-Samples/active-directory-cordova-graphapi.git
git clone https://github.com/Azure-Samples/active-directory-dotnet-webapp-webapi-oauth2-useridentity.git
git clone https://github.com/Azure-Samples/active-directory-java-native-headless.git
git clone https://github.com/Azure-Samples/active-directory-xamarin-native-v2.git
git clone https://github.com/Azure-Samples/active-directory-node-webapi.git
#git clone https://github.com/Azure-Samples/active-directory-python-graphapi-oauth2-0-access.git
git clone https://github.com/Azure-Samples/active-directory-dotnet-native-uwp-wam.git
git clone https://github.com/Azure-Samples/active-directory-java-webapp-openidconnect.git
git clone https://github.com/Azure-Samples/active-directory-dotnet-native-multitarget.git
git clone https://github.com/Azure-Samples/active-directory-dotnet-graphapi-diffquery.git
git clone https://github.com/Azure-Samples/active-directory-dotnet-webapp-multitenant-openidconnect.git
git clone https://github.com/Azure-Samples/active-directory-dotnet-webapp-roleclaims.git
git clone https://github.com/Azure-Samples/active-directory-dotnet-web-single-sign-out.git
git clone https://github.com/AzureAD/azure-activedirectory-library-for-js.git
git clone https://github.com/AzureAD/microsoft-authentication-library-for-dotnet.git

cd $codeBaseDir/github/HDInsight
#git clone https://github.com/hdinsight/eventhubs-client.git
#git clone https://github.com/hdinsight/eventhubs-sample-event-producer.git
#git clone https://github.com/hdinsight/hdinsight-spark-examples.git
#git clone https://github.com/hdinsight/hdinsight-storm-examples.git
#git clone https://github.com/hdinsight/spark-streaming-data-persistence-examples.git

cd $codeBaseDir/github/CloudFoundry
git clone https://github.com/cloudfoundry-incubator/bosh-azure-cpi-release.git
git clone https://github.com/cf-platform-eng/bosh-azure-template.git
git clone https://github.com/cloudfoundry/bosh-lite

cd $codeBaseDir/github/dx
git clone https://github.com/dx-ted-emea/bigdata-labs.git
git clone https://github.com/dx-ted-emea/iot-labs.git
git clone https://github.com/MicrosoftDX/AzureLens.git
git clone https://github.com/MicrosoftDX/AMSOpsTool.git

cd $codeBaseDir/github/OfficeDev
git clone https://github.com/OfficeDev/O365-AspNetMVC-Microsoft-Graph-Connect.git
git clone https://github.com/OfficeDev/O365-UWP-Microsoft-Graph-Connect.git
git clone https://github.com/OfficeDev/O365-UWP-Microsoft-Graph-Snippets.git
git clone https://github.com/OfficeDev/Office-Add-in-Nodejs-ServerAuth.git
#git clone https://github.com/OfficeDev/CodeLabs-Office.git
git clone https://github.com/OfficeDev/Excel-Add-in-Bind-To-Table.git
git clone https://github.com/OfficeDev/O365-AspNetMVC-Microsoft-Graph-Connect.git
git clone https://github.com/OfficeDev/O365-UWP-Microsoft-Graph-Connect.git
git clone https://github.com/OfficeDev/O365-UWP-Microsoft-Graph-Snippets.git
git clone https://github.com/OfficeDev/Office-Add-in-Nodejs-ServerAuth.git
git clone https://github.com/OfficeDev/office-js-docs.git
git clone https://github.com/OfficeDev/PowerPoint-Add-in-Microsoft-Graph-ASPNET-InsertChart.git
git clone https://github.com/OfficeDev/Word-Add-in-Angular2-StyleChecker.git
git clone https://github.com/OfficeDev/Word-Add-in-AngularJS-Client-OAuth.git
git clone https://github.com/mandren/Excel-CustomXMLPart-Demo.git

cd $codeBaseDir/github/AspNet
git clone https://github.com/aspnet/benchmarks


cd $codeBaseDir/github/MicroService/samples/SmartHotel360
git clone https://github.com/Microsoft/SmartHotel360.git
git clone https://github.com/Microsoft/SmartHotel360-Azure-backend.git
git clone https://github.com/Microsoft/SmartHotel360-public-web.git
git clone https://github.com/Microsoft/SmartHotel360-mobile-desktop-apps.git
git clone https://github.com/Microsoft/SmartHotel360-Sentiment-Analysis-App.git
git clone https://github.com/Microsoft/SmartHotel360-internal-booking-apps.git

cd $codeBaseDir/github/MicroService/samples/vertx
git clone https://github.com/vert-x3/vertx-examples.git
git clone https://github.com/vert-x3/vertx-awesome.git
git clone https://github.com/sczyh30/vertx-blueprint-microservice.git
git clone https://github.com/sczyh30/vertx-kue.git
git clone https://github.com/cescoffier/vertx-microservices-workshop.git

cd $codeBaseDir/github/Finance/Accounting
git clone https://github.com/Czichy/accounting-1.git
git clone https://github.com/Czichy/ledger.git
git clone https://github.com/Czichy/fintx-accounting.git
git clone https://github.com/Czichy/tackler.git
git clone https://github.com/Czichy/abandon.git
git clone https://github.com/Czichy/ledger.fs.git
git clone https://github.com/Czichy/accounting-1.git
git clone https://github.com/koresar/medici.git
git clone https://github.com/Czichy/accountgo.git

cd $codeBaseDir/github/Finance/Homebanking
git clone https://github.com/adorsys/multibanking.git
git clone https://github.com/willuhn/hibiscus.git


cd $codeBaseDir/github/Finance/API
git clone https://github.com/Czichy/fintex.git
git clone https://github.com/Czichy/Bank-account-data-storage.git
git clone https://github.com/Czichy/FinTsPersistence.git
git clone https://github.com/hbci4j/hbci4java.git
git clone https://github.com/jschyma/open_fints_js_client.git
git clone https://github.com/mrklintscher/libfintx.git
git clone https://github.com/adorsys/hbci4java-adorsys.git

cd $codeBaseDir/github/Trading
git clone https://github.com/jamesmawm/High-Frequency-Trading-Model-with-IB.git
git clone https://github.com/trade-manager/trade-manager.git
git clone https://github.com/quantopian/pyfolio.git
git clone https://github.com/backtrader/backtrader.git

cd $codeBaseDir/github/Trading/Data
git clone https://github.com/davidastephens/pandas-finance.git
git clone https://github.com/pydata/pandas-datareader.git
git clone https://github.com/hongtaocai/googlefinance.git
git clone https://github.com/cuemacro/findatapy.git

cd $codeBaseDir/github/Trading/Quant
git clone https://github.com/Czichy/fsharp-for-quantitative-finance.git
git clone https://github.com/jsmidt/QuantPy.git
git clone https://github.com/bpsmith/tia.git
git clone https://github.com/jeffrey-liang/quantitative.git
git clone https://github.com/quantopian/empyrical.git
git clone https://github.com/wegamekinglc/VisualPortfolio.git
git clone https://github.com/benjaminmgross/visualize-wealth.git


cd $codeBaseDir/github/Trading/Pricing
git clone https://github.com/opendoor-labs/pyfin.git


cd $codeBaseDir/github/Trading/API
git clone https://github.com/Czichy/def-trade.git
git clone https://github.com/krs43/ib-csharp.git
git clone https://github.com/ryankennedyio/ib-docker.git

cd $codeBaseDir/github/Trading/Algo
git clone https://github.com/quantopian/zipline.git
git clone https://github.com/gbeced/pyalgotrade.git
git clone https://github.com/joequant/algobroker.git
git clone https://github.com/quantopian/tradingcalendar.git
git clone https://github.com/QuantConnect/Lean.git


cd $codeBaseDir/github/Trading/Risk
git clone https://github.com/quantopian/zipline.git

cd $codeBaseDir/github/Architecture
git clone https://github.com/Czichy/def-trade.git
git clone https://github.com/GiuseppeGiacoppo/Android-Clean-Architecture-with-Kotlin.git


cd $codeBaseDir/github/Benchmark
git clone https://github.com/Czichy/BenchmarkDotNet.git

cd $codeBaseDir/github/Messaging
git clone https://github.com/Czichy/BenchmarkDotNet.git

cd $codeBaseDir/github/Scaffolding
git clone https://github.com/ivanpaulovich/caju.git

cd $codeBaseDir/github/Mobile
git clone https://github.com/flutter/flutter.git

cd $codeBaseDir/github/csharp
git clone https://github.com/aalhour/C-Sharp-Algorithms.git
git clone https://github.com/quozd/awesome-dotnet.git

cd $codeBaseDir/github/Awesome
git clone https://github.com/sindresorhus/awesome.git
git clone https://github.com/vinta/awesome-python.git
git clone https://github.com/avelino/awesome-go.git
git clone https://github.com/tmrts/go-patterns.git
git clone https://github.com/tiimgreen/github-cheat-sheet.git
git clone https://github.com/alebcay/awesome-shell.git
git clone https://github.com/veggiemonk/awesome-docker.git
git clone https://github.com/gztchan/awesome-design.git
git clone https://github.com/ChristosChristofidis/awesome-deep-learning.git
git clone https://github.com/quozd/awesome-dotnet.git
git clone https://github.com/mfornos/awesome-microservices.git










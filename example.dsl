/*
 * Structurizr DSL source for example C4 model diagrams.
 *
 * Author: Simon Brown
 * License: Creative Commons Attribution 4.0 International License 
 */
workspace "Internet Banking System" {

    description "Example C4 model diagrams for a fictional Internet Banking System."

    model {
        !identifiers hierarchical

        properties {
            structurizr.groupSeparator /
        }

        customer = person "Personal Banking Customer" "A customer of the bank with one or more personal bank accounts." {
            tag "Customer"
        }

        group "Amazon Web Services" {
            email = softwareSystem "Amazon Web Services Simple Email Service" "Cloud-based email service provider." {
                tag "Amazon Web Services Simple Email Service"
            }
        }

        group "Big Bank" {
            supportStaff = person "Customer Service Staff" "Customer service staff within the bank." {
                tag "Bank Staff"
            }
            backoffice = person "Back Office Staff" "Administration and support staff within the bank." {
                tag "Bank Staff"
            }

            coreBankingSystem = softwareSystem "Core Banking System" "Handles core banking functions including customer information, bank account management, transactions, etc." {
                tag "Core Banking System"

                perspectives {
                    "Ownership" "Team A"
                }
            }

            atm = softwareSystem "ATM" "Allows customers to withdraw cash and check bank account balances." {
                tag "ATM"

                perspectives {
                    "Ownership" "Team B"
                }
            }

            internetBankingSystem = softwaresystem "Internet Banking System" "Allows customers to view information about their bank accounts and make payments via the web." {
                tag "Internet Banking System" 

                customer -> internetBankingSystem "Views account balances and makes payments using"
                internetBankingSystem -> coreBankingSystem "Gets bank account information from and makes payments using"
                internetBankingSystem -> email "Sends e-mails to customers using"
                email -> customer "Sends e-mails to"

                ui = container "UI" "Single-page app that provides Internet banking functionality to customers via their web browser." "JavaScript and Angular" {
                    tag "Single-page Application"
                }

                staticContent = container "Static Content" "HTML, CSS, JavaScript, etc." "Directory" {
                    tag "Directory"
                }

                databaseSchema = container "Database" "User account information, access logs, etc." "MySQL Database Schema" {
                    tag "Relational Database Schema"
                }

                statementStore = container "Statement Store" "Bank account statements rendered as PDF files." "Amazon Web Services S3 Bucket" {
                    tag "Amazon Web Services S3 Bucket"
                }

                backend = container "Backend" "Provides Internet banking functionality via a JSON/HTTP API." "Java and Spring Boot" {
                    tag "Server-side Application"
                    ui -> this "Makes API requests to" "JSON/HTTP"

                    signinApi = component "Sign In API" "API endpoint for customer sign in." "Spring MVC"
                    accountsSummaryApi = component "Accounts Summary API" "API endpoint for bank accounts summary information." "Spring MVC"
                    statementApi = component "Statement API" "API endpoint for access to PDF statements." "Spring MVC"
                    statementComponent = component "Statement Component" "Provides access to PDF statements." "Spring Bean"
                    securityComponent = component "Security Component" "Provides functionality related to signing in, changing passwords, etc." "Spring Bean"
                    coreBankingSystemAdapter = component "Core Banking System Adapter" "A Java wrapper around the API provided by the Core Banking System." "Spring Bean"
                    emailComponent = component "Email Component" "Sends e-mails to users." "Spring Bean"

                    ui -> signinApi "Makes sign in requests to" "JSON/HTTP"
                    ui -> accountsSummaryApi "Requests a list of bank accounts from" "JSON/HTTP"
                    ui -> statementApi "Requests statements from" "JSON/HTTP"
                    signinApi -> securityComponent "Validates credentials using"
                    accountsSummaryApi -> coreBankingSystemAdapter "Requests lists of bank accounts from"
                    accountsSummaryApi -> securityComponent "Validates authentication token using" 
                    securityComponent -> databaseSchema "Reads from and writes to" "MySQL protocol"
                    securityComponent -> emailComponent "Sends emails using"
                    coreBankingSystemAdapter -> coreBankingSystem "Makes API requests to" "XML/HTTPS"
                    statementApi -> securityComponent "Validates authentication token using" 
                    statementApi -> statementComponent "Requests statements from" 
                    statementComponent -> statementStore "Reads from and writes to" "AWS S3 API/HTTP"
                    statementComponent -> coreBankingSystemAdapter "Requests statement information from"
                    emailComponent -> email "Sends e-mails to customers using" "AWS SES API/HTTP"
                }

                customer -> staticContent "Loads the UI from"
                customer -> ui "Views account balances and makes payments using"
                staticContent -> ui "Delivers" {
                    properties {
                        structurizr.inspection.model.relationship.technology ignore
                    }                    
                }

                perspectives {
                    "Ownership" "Team C"
                }
            }
        }

        customer -> supportStaff "Asks questions to" "Telephone"
        supportStaff -> coreBankingSystem "Support customers using"
        customer -> atm "Withdraws cash using"
        atm -> coreBankingSystem "Makes transactions using"
        backoffice -> coreBankingSystem "Investigate and troubleshoot problems using"

        dev = deploymentEnvironment "Development" {
            wan = deploymentNode "Big Bank Wide Area Network" {
                laptop = deploymentNode "Developer Laptop" {
                    technology "Microsoft Windows 11 or Apple macOS"

                    deploymentNode "Web Browser" {
                        technology "Chrome, Firefox, Safari, or Edge"

                        instanceOf internetBankingSystem.ui
                    }
                    deploymentNode "Web Server Container" {
                        technology "Docker Container"
                        tag "Docker"
                        deploymentNode "Web Server" {
                            technology "nginx"

                            instanceOf internetBankingSystem.staticContent
                        }
                    }
                    deploymentNode "Java Virtual Machine" {
                        technology "Eclipse Temurin - JDK 21 - LTS"

                        instanceOf internetBankingSystem.backend
                    }
                    deploymentNode "Database Server Container" {
                        technology "Docker Container"
                        tag "Docker"
                        deploymentNode "Database Server" {
                            technology "MySQL 8.4 LTS"

                            developerDatabaseInstance = instanceOf internetBankingSystem.databaseSchema
                        }
                    }
                    deploymentNode "Statement Store Server Container" {
                        technology "Docker Container"
                        tag "Docker"
                        deploymentNode "Statement Store Server" {
                            technology "MinIO"

                            instanceOf internetBankingSystem.statementStore
                        }
                    }
                    deploymentNode "Mock Simple Email Service" {
                        technology "Docker Container"
                        tag "Docker"
                        instanceOf email
                    }
                }
                deploymentNode "Big Bank Data Center" {
                    deploymentNode "corebanking-dev" {
                        technology "Ubuntu 24.04 LTS"

                        instanceOf coreBankingSystem
                    }
                }

                properties {
                    structurizr.inspection.model.deploymentnode.technology ignore
                }
            }
        }

        live = deploymentEnvironment "Live" {
            customerComputer = deploymentNode "Customer's computer" {
                technology "Microsoft Windows or Apple macOS"

                webBrowser = deploymentNode "Web Browser" {
                    technology "Chrome, Firefox, Safari, or Edge"

                    instanceOf internetBankingSystem.ui
                }
            }

            group "Big Bank" {
                deploymentNode "Big Bank Data Center" {
                    deploymentNode "corebanking-live" {
                        technology "Ubuntu 24.04 LTS"

                        instanceOf coreBankingSystem
                    }

                    properties {
                        structurizr.inspection.model.deploymentnode.technology ignore
                    }
                }
            }

            group "Amazon Web Services" {
                aws-region = deploymentNode "eu-west-1" {
                    technology "Amazon Web Services Region"

                    instanceOf email

                    s3 = deploymentNode "Cloud Object Storage" {
                        technology "Amazon Web Services Simple Storage Service"

                        staticContentBucket = deploymentNode "Static Content Store" {
                            technology "S3 Bucket"

                            instanceOf internetBankingSystem.staticContent
                        }
                        statementStoreInstance = instanceOf internetBankingSystem.statementStore {
                            perspectives {
                                "Security" "Objects are server-side encrypted using AES-256."
                            }
                        }
                    }

                    alb = infrastructureNode "Load Balancer" {
                        technology "Application Load Balancer"
                        description "Forwards incoming HTTPS traffic to the Backend."
                    }

                    deploymentNode "Serverless Compute Engine" {
                        technology "Amazon Web Services Fargate"

                        deploymentNode "Backend Container" {
                            technology "Docker Container"
                            tag "Docker"
                            instances "1..10"

                            deploymentNode "Java Virtual Machine" {
                                technology "Eclipse Temurin - JDK 21 - LTS"
                                backendInstance = instanceOf internetBankingSystem.backend
                            }
                        }
                    }

                    deploymentNode "Relational Database Service" {
                        technology "Amazon Web Services Relational Database Service"

                        deploymentNode "Database Server" {
                            technology "MySQL 8.4 LTS"
                            dbInstance = instanceOf internetBankingSystem.databaseSchema
                        }
                    }

                    directConnect = infrastructureNode "Network Bridge" "Provides a private dedicated network connection between AWS and the on-premises network." "Amazon Web Services Direct Connect"
                }
            }

            group "Cloudflare" {
                cloudflare = deploymentNode "DNS Services" {
                    technology "Cloudflare DNS"
                    
                    ibCname = infrastructureNode "ib.bigbank.com" {
                        description "Proxied DNS CNAME record providing cached access to static content."
                        technology "DNS CNAME"
                        this -> live.aws-region.s3.staticContentBucket "Is an alias for"
                    }
                    ibBackendCname = infrastructureNode "ib-api.bigbank.com" {
                        description "Unproxied DNS CNAME record providing access to the Internet Banking System Backend."
                        technology "DNS CNAME"
                    }
                }
            }

            internetBankingSystem.ui -/> internetBankingSystem.backend {
                internetBankingSystem.ui -> cloudflare.ibBackendCname "Makes API requests to" "JSON/HTTPS"
                cloudflare.ibBackendCname -> aws-region.alb "Is an alias for" ""
                aws-region.alb -> internetBankingSystem.backend "Forwards API requests to"
            }

            internetBankingSystem.backend -/> coreBankingSystem {
                internetBankingSystem.backend -> aws-region.directConnect "Gets bank account information from and makes payments using"
                aws-region.directConnect -> coreBankingSystem "Gets bank account information from and makes payments using" {
                    tag "via Private Network Connection"
                }
            }
            
            !relationships "internetBankingSystem.backend -> internetBankingSystem.databaseSchema" {
                technology "MySQL protocol/TLS"
            }

            !relationships "internetBankingSystem.backend -> internetBankingSystem.statementStore" {
                technology "AWS S3 API/HTTPS"
            }

            !relationships "internetBankingSystem.backend -> email" {
                technology "AWS SES API/HTTPS"
            }
        }
    }

    views {
        styles {
            element "Element" {
                shape RoundedBox
                strokeWidth 7
            }
            relationship "Relationship" {
                thickness 4
                width 300
            }
            element "Person" {
                fontSize 22
                shape Person
            }
            element "Customer" {
                color #297e06
                stroke #297e06
            }
            element "Bank Staff" {
                color #1A849C
                stroke #1A849C
            }
            element "Internet Banking System" {
                colour #1168bd
                stroke #1168bd
            }
            element "Container" {
                colour #1168bd
                stroke #1168bd
            }
            element "Directory" {
                shape Folder
            }
            element "Server-side Application" {
                shape shell
            }
            element "Single-page Application" {
                shape WebBrowser
            }
            element "Relational Database Schema" {
                shape Cylinder
            }
            element "Amazon Web Services S3 Bucket" {
                shape Bucket
            }
            element "Component" {
                shape Component
                colour #1168bd
                stroke #1168bd
            }
            element "Amazon Web Services Simple Email Service" {
                stroke #bf101d
                colour #bf101d
            }
            element "Core Banking System" {
                stroke #ed8609
                colour #ed8609
            }
            element "ATM" {
                stroke #8411bd
                colour #8411bd
            }
            element "Group" {
                strokeWidth 5
            }
            element "Boundary" {
                strokeWidth 5
            }
            element "Deployment Node" {
                strokeWidth 3
            }
            element "Infrastructure Node" {
                shape ellipse
            }
            relationship "via Private Network Connection" {
                style solid
            }
        }

        !const PLANTUML_STYLES_LIGHT """
            <style>
                root {
                    BackgroundColor: #ffffff;
                }
                element {
                    BackgroundColor: #ffffff;
                    FontColor: #111111;
                    LineColor: #111111;
                }
            </style>
        """

        !const PLANTUML_STYLES_DARK """
            <style>
                root {
                    BackgroundColor: #111111;
                }
                element {
                    BackgroundColor: #111111;
                    FontColor: #cccccc;
                    LineColor: #cccccc;
                }
            </style>
        """

        properties {
            "plantuml.url" "https://plantuml.com/plantuml"
            "plantuml.format" "svg"
            "plantuml.inline" "true"
            "structurizr.sort" "created"
            "structurizr.metadata" "false"
            "structurizr.boundaryPadding" "50"
            "structurizr.groupPadding" "50"
            "structurizr.deploymentNodePadding" "50"
        }

        systemlandscape "SystemLandscape" {
            description "A partial system landscape diagram for a fictional bank | Simon Brown | c4model.com | License: CC BY 4.0"

            include *

            animation {
                internetBankingSystem customer coreBankingSystem email
                atm supportStaff backoffice
            }
        }

        systemcontext internetBankingSystem "SystemContext" {
            description "The system context diagram for a fictional Internet Banking System | Simon Brown | c4model.com | License: CC BY 4.0"

            include *

            animation {
                internetBankingSystem
                customer
                coreBankingSystem
                email
            }

            properties {
                structurizr.groups false
            }

            default
        }

        container internetBankingSystem "Containers" {
            description "The container diagram for the Internet Banking System | Simon Brown | c4model.com | License: CC BY 4.0"

            include *

            animation {
                customer coreBankingSystem email
                internetBankingSystem.ui
                internetBankingSystem.staticContent
                internetBankingSystem.backend
                internetBankingSystem.databaseSchema
                internetBankingSystem.statementStore
            }
        }

        component internetBankingSystem.backend "Components" {
            description "The component diagram for the Internet Banking System Backend | Simon Brown | c4model.com | License: CC BY 4.0"

            include *

            animation {
                internetBankingSystem.ui internetBankingSystem.databaseSchema internetBankingSystem.statementStore email coreBankingSystem
                internetBankingSystem.backend.signinApi internetBankingSystem.backend.securityComponent internetBankingSystem.backend.emailComponent
                internetBankingSystem.backend.accountsSummaryApi internetBankingSystem.backend.coreBankingSystemAdapter
                internetBankingSystem.backend.statementApi internetBankingSystem.backend.statementComponent
            }
        }

        !const CORE_BANKING_SYSTEM_ADAPTER_CODE """
                set separator none
                package com.bigbank.ib.component.corebankingsystem {

                    +interface CoreBankingSystemAdapter {
                        +BankAccount[] getBankAccounts(Customer)
                    }

                    ~class CoreBankingSystemAdapterImpl {
                    }

                    ~class CoreBankingSystemConnection {
                        ~CoreBankingSystemConnection : Response execute(Request)
                    }
                    
                    ~interface Request {
                        toXml()
                    }
                    
                    ~class BankAccountsRequest {
                        -Customer customer
                    }
                    
                    ~class BankAccountsResponse {
                        -BankAccount[] accounts
                    }

                    ~interface Response {
                        fromXml()
                    }

                    CoreBankingSystemAdapterImpl .u.|> CoreBankingSystemAdapter
                    
                    CoreBankingSystemAdapterImpl ..> "1..20" CoreBankingSystemConnection : initialises and pools
                    CoreBankingSystemAdapterImpl ..> BankAccountsRequest : creates
                    CoreBankingSystemConnection ..> Request : executes
                    CoreBankingSystemConnection ..> Response : creates

                    Request <|.. BankAccountsRequest 
                    Response <|.. BankAccountsResponse 

                }
            """

        image internetBankingSystem.backend.coreBankingSystemAdapter "Code" {
            title "Code View: Internet Banking System - Backend - Core Banking System Adapter"
            description "A summary of the implementation details for the Core Banking System Adapter component | Simon Brown | c4model.com | License: CC BY 4.0"

            light {
                plantuml """
                    @startuml
                    ${PLANTUML_STYLES_LIGHT}
                    ${CORE_BANKING_SYSTEM_ADAPTER_CODE}
                    @enduml
                    """
            }

            dark {
                plantuml """
                    @startuml
                    ${PLANTUML_STYLES_DARK}
                    ${CORE_BANKING_SYSTEM_ADAPTER_CODE}
                    @enduml
                    """
            }
        }

        dynamic internetBankingSystem.backend "Dynamic-Collaboration" {
            description "Summarises how the sign in feature works in the single-page application | Simon Brown | c4model.com | License: CC BY 4.0"

            internetBankingSystem.ui -> internetBankingSystem.backend.signinApi "Submits credentials to"
            internetBankingSystem.backend.signinApi -> internetBankingSystem.backend.securityComponent "Validates credentials using"
            internetBankingSystem.backend.securityComponent -> internetBankingSystem.databaseSchema "select * from users where username = ?"
            internetBankingSystem.databaseSchema -> internetBankingSystem.backend.securityComponent "Returns user data to"
            internetBankingSystem.backend.securityComponent -> internetBankingSystem.backend.signinApi "Issues a session token if authentication succeeds"
            internetBankingSystem.backend.signinApi -> internetBankingSystem.ui "Sends back a session token to"

            properties {
                plantuml.sequenceDiagram true
                plantuml.title false
                structurizr.zoomOnAnimation true
            }
        }

        image internetBankingSystem.backend "Dynamic-Sequence" {
            plantuml "Dynamic-Collaboration"
        }

        deployment internetBankingSystem dev "Deployment-Development" {
            description "An example development deployment scenario for the Internet Banking System | Simon Brown | c4model.com | License: CC BY 4.0"

            include *

            animation {
                internetBankingSystem.backend 
                internetBankingSystem.ui
                internetBankingSystem.staticContent 
                internetBankingSystem.databaseSchema 
                internetBankingSystem.statementStore
                email
                coreBankingSystem
            }
        }

        deployment internetBankingSystem live "Deployment-Live" {
            description "An example live deployment scenario for the Internet Banking System | Simon Brown | c4model.com | License: CC BY 4.0"

            include *

            animation {
                live.cloudflare.ibCname
                internetBankingSystem.staticContent
                internetBankingSystem.ui
                live.cloudflare.ibBackendCname
                live.aws-region.alb
                internetBankingSystem.backend
                internetBankingSystem.databaseSchema 
                internetBankingSystem.statementStore
                email
                coreBankingSystem
                live.aws-region.directConnect
            }
        }

    }

    configuration {
        scope softwaresystem
    }

    properties {
        structurizr.inspection.model.softwaresystem.documentation ignore
        structurizr.inspection.model.softwaresystem.decisions ignore
        structurizr.inspection.model.relationship.technology ignore
        structurizr.inspection.model.deploymentnode.description ignore
    }

}
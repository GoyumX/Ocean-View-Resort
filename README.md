# 🏖️ Ocean View Resort - Hotel Reservation Management System

[![Java](https://img.shields.io/badge/Java-8+-orange.svg)](https://www.oracle.com/java/)
[![Servlet](https://img.shields.io/badge/Servlet-4.0-blue.svg)](https://jakarta.ee/specifications/servlet/)
[![JSP](https://img.shields.io/badge/JSP-2.3-green.svg)](https://jakarta.ee/specifications/pages/)
[![Tomcat](https://img.shields.io/badge/Tomcat-9.x-yellow.svg)](https://tomcat.apache.org/)
[![License](https://img.shields.io/badge/License-MIT-red.svg)](LICENSE)

A comprehensive web-based hotel reservation management system built with Java EE (Servlets & JSP) following the Model 2 (MVC) architecture pattern. Designed for hotel staff to efficiently manage room reservations, guest information, and billing operations.


---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Technology Stack](#-technology-stack)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Usage](#-usage)
- [Project Structure](#-project-structure)
- [Screenshots](#-screenshots)
- [API Documentation](#-api-documentation)
- [Testing](#-testing)
- [Contributing](#-contributing)
- [License](#-license)
- [Contact](#-contact)

---

## 🌟 Overview

Ocean View Resort is a popular beachside hotel in Galle, Sri Lanka, serving hundreds of guests monthly. This system replaces manual reservation management with an efficient computerized solution, eliminating booking conflicts and operational delays.

### Problem Statement

The hotel previously managed reservations manually, leading to:
- ❌ Booking conflicts and double bookings
- ❌ Delayed processing times
- ❌ Difficulty tracking guest information
- ❌ Manual bill calculations prone to errors
- ❌ No centralized dashboard for operations overview

### Solution

A web-based reservation management system that provides:
- ✅ Unique reservation number assignment
- ✅ Centralized guest information management
- ✅ Automated bill calculation
- ✅ Real-time reservation status tracking
- ✅ Search and filter capabilities
- ✅ Role-based access control
- ✅ Comprehensive reporting dashboard

---

## ✨ Features

### 🔐 User Authentication
- Secure login with username and password
- Session management (30-minute timeout)
- Role-based access control (Admin, Manager, Staff)
- Default user accounts for testing

### 📝 Reservation Management
- **Create Reservations**: Auto-generated unique reservation numbers (OVR####)
- **View Details**: Complete booking information display
- **Edit Reservations**: Modify existing bookings with automatic recalculation
- **Delete Reservations**: Remove reservations with confirmation
- **Search**: Find reservations by guest name
- **Status Tracking**: CONFIRMED → CHECKED_IN → CHECKED_OUT → CANCELLED

### 💰 Billing System
- Automatic cost calculation based on:
  - Room type (Single, Double, Deluxe, Suite)
  - Number of nights
  - Predefined room rates
- Professional invoice generation
- Print-ready bills
- Itemized charge breakdown

### 📊 Dashboard & Analytics
- Total reservations count
- Active reservations tracking
- Confirmed bookings overview
- Total revenue calculation
- Quick access to recent reservations

### 🏨 Room Management
Room types and rates:
- **Single Room**: LKR 5,000.00/night
- **Double Room**: LKR 8,000.00/night
- **Deluxe Room**: LKR 12,000.00/night
- **Suite**: LKR 20,000.00/night

### 📚 Help & Documentation
- Comprehensive user guide
- Step-by-step instructions
- Troubleshooting section
- Best practices for staff

### 🎨 User Interface
- Responsive design (mobile, tablet, desktop)
- Modern gradient-based styling
- Intuitive navigation
- Professional layouts
- Status color coding

---

## 🛠️ Technology Stack

### Backend
- **Java SE 8+** - Core programming language
- **Java Servlets 4.0** - Request handling and control logic
- **JSP 2.3** - Dynamic web page generation
- **JSTL 1.2** - JSP Standard Tag Library

### Frontend
- **HTML5** - Markup
- **CSS3** - Styling with gradients and modern design
- **JavaScript** - Client-side interactivity
- **Responsive Design** - Mobile-first approach

### Server
- **Apache Tomcat 9.x** - Servlet container

### Build Tool
- **Maven 3.x** - Dependency management and build automation

### Data Storage
- **File-based storage** - Text files with pipe-delimited format
  - `users.txt` - User authentication data
  - `reservations.txt` - Reservation records

### Development Tools
- **IntelliJ IDEA** - Primary IDE
- **Git** - Version control
- **PlantUML** - Diagram generation

---

## 🏗️ Architecture

### Pattern: Model 2 (Web MVC)

The application follows the **Model 2 Architecture**, a Java EE standard pattern that separates concerns into three distinct layers:
```
┌─────────────────────────────────────────┐
│     PRESENTATION LAYER (View)          │
│  • JSP pages for rendering             │
│  • CSS for styling                     │
│  • Minimal JavaScript                  │
└─────────────┬───────────────────────────┘
              │ HTTP Request/Response
┌─────────────▼───────────────────────────┐
│     CONTROLLER LAYER                    │
│  • Servlet classes                     │
│  • Request routing                     │
│  • Session management                  │
└─────────────┬───────────────────────────┘
              │ Method Calls
┌─────────────▼───────────────────────────┐
│     MODEL LAYER (Business Logic)       │
│  • Entity classes (Reservation, User)  │
│  • DAO classes (Data Access Objects)   │
│  • Business rules and validation       │
└─────────────┬───────────────────────────┘
              │ File I/O
┌─────────────▼───────────────────────────┐
│     DATA LAYER (Persistence)           │
│  • users.txt                           │
│  • reservations.txt                    │
└─────────────────────────────────────────┘
```

### Key Architectural Decisions

1. **No Framework Dependencies**: Pure Java EE implementation without Spring, Hibernate, or other frameworks
2. **File-Based Storage**: Simple, lightweight persistence suitable for small to medium deployments
3. **Session-Based Authentication**: Standard HTTP session management
4. **Server-Side Rendering**: JSP-based views for broad compatibility
5. **Separation of Concerns**: Clear layer boundaries with minimal coupling

### Design Patterns Used

- **MVC (Model-View-Controller)** - Overall architecture
- **DAO (Data Access Object)** - Data persistence abstraction
- **Singleton** - Session management
- **Front Controller** - Servlet-based request routing
- **Factory** - Object creation in DAOs

---


## 🚀 Installation

### Method 1: Using IntelliJ IDEA (Recommended)

#### Step 1: Clone the Repository
```bash
git clone https://github.com/yourusername/ocean-view-resort.git
cd ocean-view-resort
```

#### Step 2: Open in IntelliJ IDEA
1. Open IntelliJ IDEA
2. `File` → `Open`
3. Select the `ocean-view-resort` folder
4. Wait for Maven to download dependencies

#### Step 3: Configure Tomcat
1. `Run` → `Edit Configurations...`
2. Click `+` → `Tomcat Server` → `Local`
3. **Server Tab:**
   - Click `Configure...` next to Application Server
   - Select your Tomcat installation directory
   - Click `OK`
4. **Deployment Tab:**
   - Click `+` → `Artifact...`
   - Select `OceanViewResort:war exploded`
   - Application context: `/OceanViewResort`
5. Click `Apply` → `OK`

#### Step 4: Build the Project
```bash
mvn clean install
```

Or in IntelliJ:
1. Open Maven tool window (`View` → `Tool Windows` → `Maven`)
2. Expand `Lifecycle`
3. Double-click `clean` then `install`

#### Step 5: Run the Application
1. Click the green **Run** button (▶️)
2. Wait for Tomcat to start
3. Browser should automatically open to: `http://localhost:8080/OceanViewResort/`

---

### Method 2: Command Line (Manual Setup)

#### Step 1: Clone and Build
```bash
git clone https://github.com/yourusername/ocean-view-resort.git
cd ocean-view-resort
mvn clean package
```

#### Step 2: Deploy to Tomcat
```bash
# Copy WAR file to Tomcat
cp target/OceanViewResort.war /path/to/tomcat/webapps/

# Start Tomcat
# Windows:
C:\apache-tomcat-9.0.xx\bin\startup.bat

# Mac/Linux:
/opt/tomcat/bin/startup.sh
```

#### Step 3: Access Application
Open browser to: `http://localhost:8080/OceanViewResort/`

---

### Method 3: Using Eclipse

1. Import as Maven project: `File` → `Import` → `Existing Maven Projects`
2. Right-click project → `Properties` → `Targeted Runtimes` → Add Tomcat 9
3. Right-click project → `Run As` → `Run on Server`
4. Select Tomcat 9 → `Finish`

---

## 💻 Usage

### Default Login Credentials

The system comes with three pre-configured user accounts:

| Username | Password | Role | Access Level |
|----------|----------|------|--------------|
| `admin` | `admin123` | ADMIN | Full system access + user management |
| `manager` | `manager123` | ADMIN | Full access to reservations + reports |
| `staff` | `staff123` | STAFF | Create/view/edit reservations |

### Quick Start Guide

#### 1. Login
```
1. Navigate to http://localhost:8080/OceanViewResort/
2. Enter username: admin
3. Enter password: admin123
4. Click "Login"
```

#### 2. Create Your First Reservation
```
1. Click "New Reservation" in the sidebar
2. System auto-generates reservation number (e.g., OVR0001)
3. Fill in guest details:
   - Guest Name: John Doe
   - Contact: 0771234567
   - Address: 123 Beach Road, Galle
   - Email: john@example.com (optional)
4. Select room type: Double Room
5. Enter number of guests: 2
6. Select check-in date: Tomorrow
7. Select check-out date: 2 days from now
8. Click "Create Reservation"
9. System calculates total: LKR 16,000.00 (LKR 8,000 × 2 nights)
```

#### 3. View Dashboard
```
1. Click "Dashboard" in sidebar
2. View statistics:
   - Total Reservations
   - Active Reservations
   - Confirmed Bookings
   - Total Revenue
3. See list of active reservations
```

#### 4. Search Reservations
```
1. Click "Reservations" in sidebar
2. Enter guest name in search box
3. Click "Search"
4. Results displayed in table
```

#### 5. Generate Bill
```
1. Open reservation details
2. Click "Generate Bill"
3. Review itemized charges
4. Click "Print Bill" to print or save as PDF
```

#### 6. Update Status
```
1. Open reservation details
2. Click status button:
   - "Confirmed" - Initial booking status
   - "Checked In" - Guest has arrived
   - "Checked Out" - Guest has departed
   - "Cancelled" - Booking cancelled
3. Status updates immediately
```


### Key Files Explanation

#### Model Layer (`com.oceanview.model`)
- **Reservation.java**: Entity class representing a hotel booking
  - Properties: reservationNumber, guestName, roomType, dates, amount, status
  - Methods: calculateTotalAmount(), getRoomRate(), getNumberOfNights()
  
- **User.java**: Entity class for system users
  - Properties: username, password, fullName, role, email
  - Used for authentication and session management

#### DAO Layer (`com.oceanview.dao`)
- **ReservationDAO.java**: Handles all reservation data operations
  - CRUD operations (Create, Read, Update, Delete)
  - Search by guest name
  - Generate reservation numbers
  - Calculate statistics
  - File I/O operations
  
- **UserDAO.java**: Manages user authentication and data
  - User authentication
  - User management
  - Default user creation
  - Password management

#### Controller Layer (`com.oceanview.servlet`)
- **LoginServlet.java**: Handles user login
- **LogoutServlet.java**: Handles user logout and session cleanup
- **DashboardServlet.java**: Displays dashboard with statistics
- **ReservationServlet.java**: Main controller for reservation operations
- **HelpServlet.java**: Displays help documentation

#### View Layer (`webapp/WEB-INF/views`)
- All JSP files for rendering pages
- Includes for reusable components (header, sidebar)
- CSS for styling


---

## 📞 Contact

### Project Maintainer
- **Name**: Goyum Methma

- **GitHub**: [@goyumx](https://github.com/goyumx)

---

## 🙏 Acknowledgments

- **Apache Tomcat Team** - For the excellent servlet container
- **Oracle/Sun Microsystems** - For Java EE specifications
- **Maven Central** - For dependency hosting
- **IntelliJ IDEA** - For the powerful IDE
- **Stack Overflow Community** - For endless solutions
- **Ocean View Resort Staff** - For providing the real-world requirements

---

## 📊 Project Status

**Current Version**: 1.0.0  
**Status**: Active Development  
**Last Updated**: February 2024

---

## 🎓 Academic Information

This project was developed as part of coursework requirements:

**Course**: CIS6003 Advanced Programming 
**Institution**: Cardiff Metropolitan University
**Semester**: S01/3 
**Assignment**: Hotel Reservation Management System  

**Learning Outcomes Achieved**:
- ✅ Java EE web application development
- ✅ MVC architecture implementation
- ✅ Session management and authentication
- ✅ File-based data persistence
- ✅ Responsive web design
- ✅ Software documentation

---





## 🎯 Quick Links

- [📥 Download Latest Release](https://github.com/yourusername/ocean-view-resort/releases)
- [🐛 Report a Bug](https://github.com/yourusername/ocean-view-resort/issues/new?template=bug_report.md)
- [💡 Request a Feature](https://github.com/yourusername/ocean-view-resort/issues/new?template=feature_request.md)
- [📖 View Documentation](docs/)
- [🎨 View Screenshots](screenshots/)

---

<div align="center">

### ⭐ If you find this project useful, please consider giving it a star!

[⬆ Back to Top](#-ocean-view-resort---hotel-reservation-management-system)

</div>

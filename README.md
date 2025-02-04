# CBDC [Central Bank Digital Currency] Prototype Application.

# Deployment Url : https://cbdc-phi.vercel.app/


# CBDC API Documentation

## Base URL
`/api/v1`

## Authentication
All protected routes require authentication middleware
Authentication header required for protected routes

## Routes

### Authentication `/user`
| Method | Endpoint | Auth Required | Parameters | Description |
|--------|----------|---------------|------------|-------------|
| POST | `/register` | No | `{name, email, password}` | Create account |
| POST | `/login` | No | `{email, password}` | Login |
| GET | `/logout` | Yes | - | Logout |

### User Management `/user`
| Method | Endpoint | Auth Required | Parameters | Description |
|--------|----------|---------------|------------|-------------|
| GET | `/` | Yes | - | Get all users |
| GET | `/showMe` | Yes | - | Get current user |
| PATCH | `/updateUser` | Yes | `{email, name}` | Update profile |
| PATCH | `/updateUserPassword` | Yes | `{oldPassword, newPassword}` | Update password |
| GET | `/getBalance` | Yes | `{userId}` | Get user balance |
| GET | `/:id` | Yes | 

id

 (URL param) | Get single user |

### Transactions `/transactions`
| Method | Endpoint | Auth Required | Parameters | Description |
|--------|----------|---------------|------------|-------------|
| POST | `/` | Yes | `{senderId, receiverId, amount, transactionType, description}` | Create transaction |
| GET | `/` | Yes | `{userId}` | List all transactions |
| GET | `/getSingleTransaction` | Yes | `{transactionId}` | Get transaction details |

### System `/homepage`
| Method | Endpoint | Auth Required | Parameters | Description |
|--------|----------|---------------|------------|-------------|
| GET | `/` | Yes | - | Get homepage data |
| GET | `/stats` | Yes | - | Get system statistics |

## Status Codes
- 200: OK
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 404: Not Found
- 500: Server Error

## Transaction Types
- transfer
- deposit
- withdrawal

## Models
```javascript
User {
  name: String,
  email: String,
  password: String,
  balance: Number,
  role: String
}

Transaction {
  sender: ObjectId,
  receiver: ObjectId,
  amount: Number,
  transactionType: String,
  description: String,
  status: String
}
```

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
"# CBDC-app" 

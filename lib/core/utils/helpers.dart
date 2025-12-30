import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';

class Helpers {
  // Format Currency (IDR)
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
  
  // Format Date
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }
  
  // Format Time
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
  
  // Format DateTime
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dateTime);
  }
  
  // Get Order Status Color
  static Color getOrderStatusColor(String status) {
    switch (status. toLowerCase()) {
      case 'pending':
        return AppColors. warning;
      case 'confirmed':
        return AppColors.info;
      case 'preparing': 
        return AppColors.secondary500;
      case 'ready':
        return AppColors.success;
      case 'completed': 
        return AppColors.grey500;
      case 'cancelled': 
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }
  
  // Get Order Status Text
  static String getOrderStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu Konfirmasi';
      case 'confirmed':
        return 'Dikonfirmasi';
      case 'preparing':
        return 'Sedang Disiapkan';
      case 'ready':
        return 'Siap Diambil';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default: 
        return status;
    }
  }
  
  // Show Snackbar
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger. of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  
  // Calculate Estimated Time (based on queue)
  static String calculateEstimatedTime(int queuePosition) {
    int minutes = queuePosition * 5; 
    if (minutes < 10) {
      return '5-10 Menit';
    } else if (minutes < 20) {
      return '10-15 Menit';
    } else if (minutes < 30) {
      return '15-20 Menit';
    } else {
      return '${minutes - 5}-$minutes Menit';
    }
  }
}
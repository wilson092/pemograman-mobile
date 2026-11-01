import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/data/models/forecast_item.dart';
import 'package:pemob/project/app/widgets/forecast_day_row.dart';
import 'package:pemob/project/app/widgets/forecast_hour_item.dart';
import 'package:pemob/project/app/widgets/section_header.dart';

class HourlyForecastSection extends StatelessWidget {
  final AsyncValue<List<HourlyForecast>> hourlyAsync;

  const HourlyForecastSection({super.key, required this.hourlyAsync});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(
          title: 'Prakiraan Per 3 Jam',
          subtitle: '(24 jam)',
          actionText: 'geser ›',
        ),
        const SizedBox(height: AppDimensions.space12),
        SizedBox(
          height: 98,
          child: hourlyAsync.when(
            data: (items) => ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                return ForecastHourItem(
                  time: item.time,
                  temperature: item.temperature,
                  condition: item.condition,
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class DailyForecastSection extends StatelessWidget {
  final AsyncValue<List<DailyForecast>> dailyAsync;

  const DailyForecastSection({super.key, required this.dailyAsync});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Prakiraan 5 Hari'),
        const SizedBox(height: AppDimensions.space12),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.cardPadding),
            child: dailyAsync.when(
              data: (items) => Column(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  return ForecastDayRow(
                    dayName: item.dayName,
                    condition: item.condition,
                    minTemp: item.minTemp,
                    maxTemp: item.maxTemp,
                    showDivider: index < items.length - 1,
                  );
                }),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}

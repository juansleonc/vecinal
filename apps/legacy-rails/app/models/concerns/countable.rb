module Countable
  extend ActiveSupport::Concern

  included do
    acts_as_paranoid
    scope :by, -> (users) { where(user: users) }
    scope :presents_in, -> (date, users) { with_deleted.where('created_at <= ?', date).by(users) }
    scope :presents_beetwen, -> (date1, date2, users) { where('created_at >= ? and created_at <= ?', date1, date2).by(users) }
  end

  class_methods do

    def increase_beetwen(before, now, users)
      increase = self.presents_beetwen(before, now, users).count
      before_amount = self.presents_in(before, users).count
      calc_increase increase, before_amount
    end

    def calc_increase increase, before_amount
      result = (increase.to_f * 100)/ before_amount
      if result.nan?
        0
      elsif result.infinite?
        100
      else
        result - 100
      end
    end

    def data_chart start, final, step, backward, users
      start = start.to_time
      final = final.to_time
      serie_a = Array.new
      serie_b = Array.new
      labels = Array.new

      point = 0
      while start <= final do
        
        opts = { 
          present: start.strftime('%b %d, %y'), 
          past: (start - backward).strftime('%b %d, %y'),
          present_amount: presents_in(start, users).count,
          past_amount: presents_in(start - backward, users).count,
          model: self
        }

        meta = ApplicationController.new.render_to_string( partial: 'dashboard/tooltip', locals:{ opts: opts }).gsub("\n", "")

        labels << start.strftime('%b %n %d')
        serie_a << { meta: meta, value: presents_in(start, users).count }
        serie_b << { meta: meta, value: presents_in(start - backward, users).count }
        start += step
        point += 1
      end

      {labels: labels, series: [serie_a, serie_b]}
    end

  end

  FILTER_DATES = [{time: 30.days.ago, amount: 30, step: '3.days', backward: '30.days', t_type: 'last_days', n: 30 }, 
    { time: 3.months.ago, amount: 3, backward: '3.months', t_type: 'last_months', n: 3 }, 
    { time: 6.months.ago, amount: 6, backward: '6.months', t_type: 'last_months', n: 6 }, 
    { time: 12.months.ago, amount: 12, backward: '12.months', t_type: 'last_months', n: 12 }, 
    { time: Time.now.beginning_of_year, until: Time.now.end_of_month, backward: '1.year', t_type: 'this_year' }, 
    { time: (Time.now - 1.year).beginning_of_year, until: (Time.now - 1.year).end_of_year, backward: '1.year', t_type: 'last_year' }]

  MODELS_REPORT = [
    { class: Comment,         col1: 'posts',        col2: 'comments' },
    { class: Message,         col1: 'messages',     col2: 'replies' }, 
    { class: ServiceRequest,  col1: 'open',         col2: 'closed' },
    { class: Event,           col1: 'past',         col2: 'upcoming' },
    { class: Attachment,      col1: 'files',        col2: 'storage' },
    { class: Amenity,         col1: 'amenities',    col2: 'reservations' },
    { class: Poll,            col1: 'polls',        col2: 'votes' },
    { class: Payment,         col1: 'transactions', col2: 'amount' }]

  MODELS_CHART = [User, Comment, Message, ServiceRequest, Event, Attachment, Reservation, Poll, Payment]

end
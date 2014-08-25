RSpec.describe Rack::Tracker::Facebook do
  def env
    {}
  end

  describe 'with custom audience id' do
    subject { described_class.new(env, custom_audience_id: 'custom_audience_id').render }

    it 'will push the tracking events to the queue' do
      expect(subject).to match(%r{window._fbq.push\(\['addPixelId', 'custom_audience_id'\]\)})
      expect(subject).to match(%r{window._fbq.push\(\["track", "PixelInitialized", \{\}\]\)})
    end

    it 'will add the noscript fallback' do
      expect(subject).to match(%r{https://www.facebook.com/tr\?id=custom_audience_id&amp;ev=PixelInitialized})
    end
  end

  describe 'with events' do
    def env
      {
        rack_tracker: {
          facebook: {
            event: {
              pixel_id: '123456789',
              value: '23',
              currency: 'EUR',
            }
          }
        }
      }
    end
    subject { described_class.new(env).render }

    it 'will push the tracking events to the queue' do
      expect(subject).to match(%r{\['track', '123456789', \{'value': '23', 'currency': 'EUR'\}\]})
    end

    it 'will add the noscript fallback' do
      expect(subject).to match(%r{https://www.facebook.com/offsite_event.php\?id=123456789&amp;value=23&amp;currency=EUR})
    end
  end
end
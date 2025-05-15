PREFIX=/usr
LIBDIR=/var/lib/weatherwalls
BINDIR=$(PREFIX)/bin
SCRIPT=weatherwalls.pl
EXEC=weatherwalls

.PHONY: install uninstall deps

#install: deps
#	@echo "Installing weatherwalls..."
#	rm -rf $(LIBDIR)
#	rm -f $(BINDIR)/$(EXEC)
#
#	mkdir -p $(LIBDIR)
#
#	cp -r * $(LIBDIR)
#	touch $(LIBDIR)/.env
#
#	mv $(LIBDIR)/$(SCRIPT) $(BINDIR)/$(EXEC)
#	chmod +x $(BINDIR)/$(EXEC)
#
#	sudo -u $(SUDO_USER) bash $(LIBDIR)/autostart.sh on
#
#	@echo "✅ Установка завершена: 'weatherwalls' доступен как команда"

deps:
	@echo "Installing Perl dependencies..."
	apt-get update && apt-get install -y build-essential
	cpan -i DateTime
	cpan -i File::chdir
	cpan -i WWW::ipinfo
	cpan -i DateTime::Event::Sunrise
	cpan -i HTML::TreeBuilder
	cpan -i Dotenv

uninstall:
	@echo "Removing weatherwalls..."
	rm -f $(BINDIR)/$(EXEC)
	rm -rf $(LIBDIR)
	@echo "✅ Удалено"

